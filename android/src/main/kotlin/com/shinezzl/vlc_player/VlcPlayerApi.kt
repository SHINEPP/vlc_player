package com.shinezzl.vlc_player

import MediaAudioTrack
import MediaCreateInput
import MediaSubtitleTrack
import MediaVideoTrack
import VideoViewCreateResult
import VlcApi
import VlcFlutterApi
import android.util.Log
import androidx.core.net.toUri
import com.shinezzl.vlc_player.vlc.DataSourceType
import com.shinezzl.vlc_player.vlc.HwAcc
import com.shinezzl.vlc_player.vlc.MediaEvent
import com.shinezzl.vlc_player.vlc.VideoView
import io.flutter.embedding.engine.plugins.FlutterPlugin
import org.videolan.libvlc.LibVLC
import org.videolan.libvlc.Media
import org.videolan.libvlc.MediaPlayer
import org.videolan.libvlc.interfaces.IMedia
import org.videolan.libvlc.interfaces.IMedia.AudioTrack
import org.videolan.libvlc.interfaces.IMedia.SubtitleTrack
import org.videolan.libvlc.interfaces.IMedia.VideoTrack

class VlcPlayerApi(private val binding: FlutterPlugin.FlutterPluginBinding) : VlcApi {

    companion object {
        private const val TAG = "Vlc_Player_Api"
    }

    private val objectHelper = ObjectHelper()

    private val flutterApi = VlcFlutterApi(binding.binaryMessenger)

    fun startListening() {
        Log.d(TAG, "startListening()")
        VlcApi.setUp(binding.binaryMessenger, this)
    }

    fun stopListening() {
        Log.d(TAG, "stopListening()")
        VlcApi.setUp(binding.binaryMessenger, null)
    }

    // LibVLC
    override fun createLibVlc(options: List<String>?, callback: (Result<Long>) -> Unit) {
        Log.d(TAG, "createLibVlc()")
        val libVlc = LibVLC(binding.applicationContext, options?.toMutableList())
        val libVlcId = objectHelper.putObject(libVlc)
        callback.invoke(Result.success(libVlcId))
    }

    override fun disposeLibVlc(libVlcId: Long, callback: (Result<Boolean>) -> Unit) {
        Log.d(TAG, "disposeLibVlc()")
        objectHelper.removeObject<LibVLC>(libVlcId)?.release()
        callback.invoke(Result.success(true))
    }

    // Media
    override fun createMedia(input: MediaCreateInput, callback: (Result<Long>) -> Unit) {
        Log.d(TAG, "createMedia()")
        val libVlc = objectHelper.getObject<LibVLC>(input.libVlcId ?: -1)
        val options = input.options
        val type = input.dataSourceType
        val source = input.dataSourceValue
        if (libVlc == null || type == null || source == null) {
            Log.e(TAG, "createMedia(), params contain null")
            callback.invoke(Result.failure(IllegalArgumentException()))
            return
        }

        val context = binding.applicationContext
        var throwable: Throwable? = null
        val media = when (type) {
            DataSourceType.ASSETS.index -> {
                Media(libVlc, context.assets.openFd(source))
            }

            DataSourceType.CONTENT_URI.index -> {
                try {
                    val p = context.contentResolver.openFileDescriptor(source.toUri(), "r")
                    if (p != null) Media(libVlc, p.fileDescriptor) else null
                } catch (e: Throwable) {
                    Log.e(TAG, "createMedia(), e = $e")
                    throwable = e
                    null
                }
            }

            else -> Media(libVlc, source.toUri())
        }
        if (media == null) {
            Log.e(TAG, "createMedia(), media is null")
            callback.invoke(Result.failure(throwable ?: IllegalArgumentException()))
            return
        }

        val mediaId = objectHelper.putObject(media)
        Log.d(TAG, "createMedia(), mediaId = $mediaId")

        when (input.hwAcc) {
            HwAcc.DISABLED.index -> media.setHWDecoderEnabled(false, false)
            HwAcc.DECODING.index -> {
                media.setHWDecoderEnabled(true, true)
                media.addOption(":no-mediacodec-dr")
                media.addOption(":no-omxil-dr")
            }

            HwAcc.FULL.index -> media.setHWDecoderEnabled(true, true)
            else -> media.setHWDecoderEnabled(true, false)
        }

        options?.forEach { media.addOption(it) }
        callback.invoke(Result.success(mediaId))
    }

    override fun setMediaEventListener(mediaId: Long, callback: (Result<Boolean>) -> Unit) {
        val media = objectHelper.getObject<Media>(mediaId)
        media?.setEventListener { event ->
            Log.d(TAG, "setMediaEventListener(), eventListener, event = ${event.type}")
            when (event.type) {
                IMedia.Event.MetaChanged -> {
                    flutterApi.onMediaEvent(mediaId, MediaEvent.PARSED_CHANGED.index) {}
                }

                IMedia.Event.SubItemAdded -> {
                    flutterApi.onMediaEvent(mediaId, MediaEvent.SUB_ITEM_ADDED.index) {}
                }

                IMedia.Event.DurationChanged -> {
                    flutterApi.onMediaEvent(mediaId, MediaEvent.DURATION_CHANGED.index) {}
                }

                IMedia.Event.ParsedChanged -> {
                    flutterApi.onMediaEvent(mediaId, MediaEvent.PARSED_CHANGED.index) {}
                }

                IMedia.Event.SubItemTreeAdded -> {
                    flutterApi.onMediaEvent(mediaId, MediaEvent.SUB_ITEM_TREE_ADDED.index) {}
                }
            }
        }
        callback.invoke(Result.success(true))
    }

    override fun mediaParseAsync(mediaId: Long, callback: (Result<Boolean>) -> Unit) {
        Log.d(TAG, "mediaParseAsync()")
        val media = objectHelper.getObject<Media>(mediaId)
        val result = media?.parseAsync(IMedia.Parse.ParseLocal or IMedia.Parse.ParseNetwork) ?: false
        callback.invoke(Result.success(result))
    }

    override fun mediaGetVideoTrack(mediaId: Long, callback: (Result<MediaVideoTrack>) -> Unit) {
        Log.d(TAG, "mediaGetVideoTrack()")
        val media = objectHelper.getObject<Media>(mediaId)
        val tracks = media?.tracks ?: emptyArray()
        val videoTrack = tracks.firstOrNull { it is VideoTrack } as VideoTrack?
        val result = MediaVideoTrack(
            duration = media?.duration,
            height = videoTrack?.height?.toLong(),
            width = videoTrack?.width?.toLong(),
            sarDen = videoTrack?.sarDen?.toLong(),
            sarNum = videoTrack?.sarNum?.toLong(),
            frameRateDen = videoTrack?.frameRateDen?.toLong(),
            frameRateNum = videoTrack?.frameRateNum?.toLong(),
            orientation = videoTrack?.orientation?.toLong(),
            projection = videoTrack?.projection?.toLong(),
        )
        callback.invoke(Result.success(result))
    }

    override fun mediaGetAudioTrack(mediaId: Long, callback: (Result<List<MediaAudioTrack>>) -> Unit) {
        Log.d(TAG, "mediaGetAudioTrack()")
        val media = objectHelper.getObject<Media>(mediaId)
        val tracks = media?.tracks ?: emptyArray()
        val audioTracks = tracks.filterIsInstance<AudioTrack>()
        val result = audioTracks.map {
            MediaAudioTrack(trackId = it.id.toLong(), channels = it.channels.toLong(), rate = it.rate.toLong(), description = it.description)
        }
        callback.invoke(Result.success(result))
    }

    override fun mediaGetSubtitleTrack(mediaId: Long, callback: (Result<List<MediaSubtitleTrack>>) -> Unit) {
        Log.d(TAG, "mediaGetSubtitleTrack()")
        val media = objectHelper.getObject<Media>(mediaId)
        val tracks = media?.tracks ?: emptyArray()
        val subtitleTracks = tracks.filterIsInstance<SubtitleTrack>()
        val result = subtitleTracks.map {
            MediaSubtitleTrack(trackId = it.id.toLong(), encoding = it.encoding, description = it.description)
        }
        callback.invoke(Result.success(result))
    }

    override fun disposeMedia(mediaId: Long, callback: (Result<Boolean>) -> Unit) {
        Log.d(TAG, "disposeMedia()")
        objectHelper.removeObject<Media>(mediaId)?.release()
        callback.invoke(Result.success(true))
    }

    // MediaPlayer
    override fun createMediaPlayer(libVlcId: Long, callback: (Result<Long>) -> Unit) {
        Log.d(TAG, "createMediaPlayer()")
        val libVlc = objectHelper.getObject<LibVLC>(libVlcId)
        if (libVlc == null) {
            callback.invoke(Result.failure(IllegalArgumentException()))
            return
        }
        val mediaPlayer = MediaPlayer(libVlc)
        val mediaPlayerId = objectHelper.putObject(mediaPlayer)
        callback.invoke(Result.success(mediaPlayerId))
    }

    override fun mediaPlayerSetMedia(mediaPlayerId: Long, mediaId: Long, callback: (Result<Boolean>) -> Unit) {
        Log.d(TAG, "mediaPlayerSetMedia()")
        val mediaPlayer = objectHelper.getObject<MediaPlayer>(mediaPlayerId)
        val media = objectHelper.getObject<Media>(mediaId)
        mediaPlayer?.media = media
        callback.invoke(Result.success(true))
    }

    override fun mediaPlayerAttachVideoView(mediaPlayerId: Long, videoViewId: Long, callback: (Result<Boolean>) -> Unit) {
        Log.d(TAG, "mediaPlayerAttachVideoView()")
        val mediaPlayer = objectHelper.getObject<MediaPlayer>(mediaPlayerId)
        val videoView = objectHelper.getObject<VideoView>(videoViewId)
        val vlcOut = mediaPlayer?.vlcVout
        vlcOut?.setVideoSurface(videoView?.textureView?.surfaceTexture())
        vlcOut?.attachViews()
        mediaPlayer?.setVideoTrackEnabled(true)
        callback.invoke(Result.success(true))
    }

    override fun mediaPlayerPlay(mediaPlayerId: Long, callback: (Result<Boolean>) -> Unit) {
        Log.d(TAG, "mediaPlayerPlay()")
        val mediaPlayer = objectHelper.getObject<MediaPlayer>(mediaPlayerId)
        mediaPlayer?.play()
        callback.invoke(Result.success(true))
    }

    override fun mediaPlayerPause(mediaPlayerId: Long, callback: (Result<Unit>) -> Unit) {
        Log.d(TAG, "mediaPlayerPause()")
        val mediaPlayer = objectHelper.getObject<MediaPlayer>(mediaPlayerId)
        mediaPlayer?.pause()
        callback.invoke(Result.success(Unit))
    }

    override fun mediaPlayerStop(mediaPlayerId: Long, callback: (Result<Unit>) -> Unit) {
        Log.d(TAG, "mediaPlayerStop()")
        val mediaPlayer = objectHelper.getObject<MediaPlayer>(mediaPlayerId)
        mediaPlayer?.stop()
        callback.invoke(Result.success(Unit))
    }

    override fun mediaPlayerIsPlaying(mediaPlayerId: Long, callback: (Result<Boolean>) -> Unit) {
        Log.d(TAG, "mediaPlayerIsPlaying()")
        val mediaPlayer = objectHelper.getObject<MediaPlayer>(mediaPlayerId)
        val isPlaying = mediaPlayer?.isPlaying ?: false
        callback.invoke(Result.success(isPlaying))
    }

    override fun mediaPlayerSetTime(mediaPlayerId: Long, time: Long, fast: Boolean, callback: (Result<Unit>) -> Unit) {
        Log.d(TAG, "mediaPlayerSetTime()")
        val mediaPlayer = objectHelper.getObject<MediaPlayer>(mediaPlayerId)
        mediaPlayer?.setTime(time, fast)
        callback.invoke(Result.success(Unit))
    }

    override fun mediaPlayerGetTime(mediaPlayerId: Long, callback: (Result<Long>) -> Unit) {
        Log.d(TAG, "mediaPlayerGetTime()")
        val mediaPlayer = objectHelper.getObject<MediaPlayer>(mediaPlayerId)
        val time = mediaPlayer?.time ?: 0L
        callback.invoke(Result.success(time))
    }

    override fun mediaPlayerSetPosition(mediaPlayerId: Long, position: Double, fast: Boolean, callback: (Result<Unit>) -> Unit) {
        Log.d(TAG, "mediaPlayerSetPosition()")
        val mediaPlayer = objectHelper.getObject<MediaPlayer>(mediaPlayerId)
        mediaPlayer?.setPosition(position.toFloat(), fast)
        callback.invoke(Result.success(Unit))
    }

    override fun mediaPlayerGetPosition(mediaPlayerId: Long, callback: (Result<Double>) -> Unit) {
        Log.d(TAG, "mediaPlayerGetPosition()")
        val mediaPlayer = objectHelper.getObject<MediaPlayer>(mediaPlayerId)
        val position = mediaPlayer?.position ?: 0f
        callback.invoke(Result.success(position.toDouble()))
    }

    override fun mediaPlayerGetLength(mediaPlayerId: Long, callback: (Result<Long>) -> Unit) {
        Log.d(TAG, "mediaPlayerGetLength()")
        val mediaPlayer = objectHelper.getObject<MediaPlayer>(mediaPlayerId)
        val length = mediaPlayer?.length ?: 0
        callback.invoke(Result.success(length))
    }

    override fun mediaPlayerSetVolume(mediaPlayerId: Long, volume: Long, callback: (Result<Unit>) -> Unit) {
        Log.d(TAG, "mediaPlayerSetVolume()")
        val mediaPlayer = objectHelper.getObject<MediaPlayer>(mediaPlayerId)
        mediaPlayer?.volume = volume.toInt()
        callback.invoke(Result.success(Unit))
    }

    override fun mediaPlayerGetVolume(mediaPlayerId: Long, callback: (Result<Long>) -> Unit) {
        Log.d(TAG, "mediaPlayerGetVolume()")
        val mediaPlayer = objectHelper.getObject<MediaPlayer>(mediaPlayerId)
        val volume = mediaPlayer?.volume ?: 100
        callback.invoke(Result.success(volume.toLong()))
    }

    override fun mediaPlayerSetRate(mediaPlayerId: Long, rate: Double, callback: (Result<Unit>) -> Unit) {
        Log.d(TAG, "mediaPlayerSetRate()")
        val mediaPlayer = objectHelper.getObject<MediaPlayer>(mediaPlayerId)
        mediaPlayer?.rate = rate.toFloat()
        callback.invoke(Result.success(Unit))
    }

    override fun mediaPlayerGetRate(mediaPlayerId: Long, callback: (Result<Double>) -> Unit) {
        Log.d(TAG, "mediaPlayerGetRate()")
        val mediaPlayer = objectHelper.getObject<MediaPlayer>(mediaPlayerId)
        val rate = mediaPlayer?.rate ?: 1f
        callback.invoke(Result.success(rate.toDouble()))
    }

    override fun disposeMediaPlayer(mediaPlayerId: Long, callback: (Result<Boolean>) -> Unit) {
        Log.d(TAG, "disposeMediaPlayer()")
        objectHelper.removeObject<MediaPlayer>(mediaPlayerId)?.release()
        callback.invoke(Result.success(true))
    }

    // Video View
    override fun createVideoView(callback: (Result<VideoViewCreateResult>) -> Unit) {
        Log.d(TAG, "createVideoView()")
        val texture = binding.textureRegistry.createSurfaceTexture()
        val videoView = VideoView(texture)
        val videoViewId = objectHelper.putObject(videoView)
        callback.invoke(Result.success(VideoViewCreateResult(objectId = videoViewId, textureId = texture.id())))
    }

    override fun videoViewSetDefaultBufferSize(videoViewId: Long, width: Long, height: Long, callback: (Result<Boolean>) -> Unit) {
        val videoView = objectHelper.getObject<VideoView>(videoViewId)
        videoView?.textureView?.surfaceTexture()?.setDefaultBufferSize(width.toInt(), height.toInt())
        callback.invoke(Result.success(true))
    }

    override fun disposeVideoView(videoViewId: Long, callback: (Result<Boolean>) -> Unit) {
        Log.d(TAG, "disposeVideoView()")
        objectHelper.removeObject<VideoView>(videoViewId)?.release()
        callback.invoke(Result.success(true))
    }
}