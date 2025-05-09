package com.shinezzl.vlc_player

import LibVlcInput
import LibVlcOutput
import MediaInput
import MediaOutput
import MediaPlayerInput
import MediaPlayerOutput
import VlcApi
import android.util.Log
import androidx.core.net.toUri
import com.shinezzl.vlc_player.vlc.DataSourceType
import com.shinezzl.vlc_player.vlc.HwAcc
import io.flutter.embedding.engine.plugins.FlutterPlugin
import org.videolan.libvlc.LibVLC
import org.videolan.libvlc.Media
import org.videolan.libvlc.MediaPlayer
import org.videolan.libvlc.interfaces.IMedia

class VlcPlayerApi(private val binding: FlutterPlugin.FlutterPluginBinding) : VlcApi {

    companion object {
        private const val TAG = "Vlc_Player_Api"
    }

    private val objectHelper = ObjectHelper()

    fun startListening() {
        Log.d(TAG, "startListening()")
        VlcApi.setUp(binding.binaryMessenger, this)
    }

    fun stopListening() {
        Log.d(TAG, "stopListening()")
        VlcApi.setUp(binding.binaryMessenger, null)
    }

    // LibVLC
    override fun createLibVlc(input: LibVlcInput, callback: (Result<LibVlcOutput>) -> Unit) {
        Log.d(TAG, "createLibVlc()")
        val options = input.options ?: emptyList()
        val libVlc = LibVLC(binding.applicationContext, options.toMutableList())
        val id = objectHelper.putObject(libVlc)
        callback.invoke(Result.success(LibVlcOutput(id)))
    }

    override fun mediaParseAsync(mediaId: Long, callback: (Result<Boolean>) -> Unit) {
        Log.d(TAG, "mediaParseAsync()")
        val media = objectHelper.getObject<Media>(mediaId)
        val result = media?.parseAsync() ?: false
        callback.invoke(Result.success(result))
    }

    override fun disposeLibVlc(libVlcId: Long, callback: (Result<Boolean>) -> Unit) {
        Log.d(TAG, "disposeLibVlc()")
        objectHelper.removeObject<LibVLC>(libVlcId)?.release()
        callback.invoke(Result.success(true))
    }

    // Media
    override fun createMedia(input: MediaInput, callback: (Result<MediaOutput>) -> Unit) {
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
        media.parseAsync(IMedia.Parse.ParseLocal or IMedia.Parse.ParseNetwork)
        val id = objectHelper.putObject(media)
        Log.d(TAG, "createMedia(), id = $id")
        callback.invoke(Result.success(MediaOutput(id)))
    }

    override fun disposeMedia(mediaId: Long, callback: (Result<Boolean>) -> Unit) {
        Log.d(TAG, "disposeMedia()")
        objectHelper.removeObject<Media>(mediaId)?.release()
        callback.invoke(Result.success(true))
    }

    // MediaPlayer
    override fun createMediaPlayer(input: MediaPlayerInput, callback: (Result<MediaPlayerOutput>) -> Unit) {
        Log.d(TAG, "createMediaPlayer()")
        val libVlc = objectHelper.getObject<LibVLC>(input.libVlcId ?: -1)
        if (libVlc == null) {
            callback.invoke(Result.failure(IllegalArgumentException()))
            return
        }
        val mediaPlayer = MediaPlayer(libVlc)
        val id = objectHelper.putObject(mediaPlayer)
        callback.invoke(Result.success(MediaPlayerOutput(id)))
    }

    override fun disposeMediaPlayer(mediaPlayerId: Long, callback: (Result<Boolean>) -> Unit) {
        Log.d(TAG, "disposeMediaPlayer()")
        objectHelper.removeObject<MediaPlayer>(mediaPlayerId)?.release()
        callback.invoke(Result.success(true))
    }
}