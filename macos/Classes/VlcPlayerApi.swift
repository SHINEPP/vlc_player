//
//  VlcPlayerApi.swift
//  Pods
//
//  Created by zhouzhenliang on 2025/5/11.
//


import FlutterMacOS
import Cocoa
import VLCKit

public class VlcPlayerApi: NSObject, VlcApi {
    
    private let messenger: FlutterBinaryMessenger
    private let objectHelper = ObjectHelper()
    private let flutterApi: VlcFlutterApi
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        flutterApi = VlcFlutterApi(binaryMessenger: messenger)
        super.init()
        
        VlcApiSetup.setUp(binaryMessenger: messenger, api: self)
    }
    
    // LibVlc
    func createLibVlc(options: [String]?, completion: @escaping (Result<Int64, Error>) -> Void) {
        print("createLibVlc()")
        let libVlc = VLCLibrary(options: options ?? [])
        let libVlcId = objectHelper.putObject(libVlc)
        completion(.success(libVlcId))
    }
    
    func disposeLibVlc(libVlcId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        print("disposeLibVlc()")
        let _ : VLCLibrary? = objectHelper.removeObject(id: libVlcId)
        completion(.success(true))
    }
    
    // Media
    func createMedia(input: MediaCreateInput, completion: @escaping (Result<Int64, Error>) -> Void) {
        print("createMedia()")
        var media: VLCMedia? = nil
        
        switch(input.dataSourceType) {
        case DataSourceType.file.rawValue:
            media = VLCMedia(path:  input.dataSourceValue ?? "")
            break
        case DataSourceType.network.rawValue:
            if let url = URL(string: input.dataSourceValue ?? "") {
                media = VLCMedia(url: url)
            }
            break
        default:
            break;
        }
        if (media == nil) {
            completion(.failure(NSError(domain: "createMedia(), dataSourceType error", code: 0)))
            return
        }
        
        let mediaWrapper = MediaWrapper(media: media!, libVlcId: input.libVlcId!, flutterApi: flutterApi)
        let mediaWrapperId = objectHelper.putObject(mediaWrapper)
        mediaWrapper.setMediaId(mediaId: mediaWrapperId)

        switch(input.hwAcc) {
        case HwAcc.decoding.rawValue:
            media?.addOption(":no-mediacodec-dr")
            media?.addOption(":no-omxil-dr")
            break
        default:
            break;
        }
        
        if let options = input.options {
            for option in options {
                media?.addOption(option)
            }
        }
        
        completion(.success(mediaWrapperId))
    }
    
    func setMediaEventListener(mediaId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        print("setMediaEventListener()")
        let mediaWrapper: MediaWrapper? = objectHelper.getObject(id: mediaId)
        mediaWrapper?.setMediaEventListener()
        completion(.success(true))
    }
    
    func mediaParseAsync(mediaId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        print("mediaParseAsync()")
        var result = false
        if let mediaWrapper: MediaWrapper = objectHelper.getObject(id: mediaId) {
            let media = mediaWrapper.getMedia()
            let libVlcId = mediaWrapper.getLibVlcId()
            if let libVlc: VLCLibrary = objectHelper.getObject(id: libVlcId) {
                let options: VLCMediaParsingOptions = [.parseNetwork, .parseLocal]
                result = media.parse(options: options, timeout: -1, library: libVlc) == 0
            }
        }
        completion(.success(result))
    }
    
    func mediaGetVideoTrack(mediaId: Int64, completion: @escaping (Result<MediaVideoTrack, Error>) -> Void) {
        print("mediaGetVideoTrack()")
        var mediaVideoTrack: MediaVideoTrack? = nil
        if let mediaWrapper: MediaWrapper = objectHelper.getObject(id: mediaId) {
            let media = mediaWrapper.getMedia()
            if let track = media.videoTracks.first {
                if track.type == .video, let vTrack = track.video {
                    mediaVideoTrack = MediaVideoTrack(
                        duration: Int64(media.length.intValue),
                        height: Int64(vTrack.height),
                        width: Int64(vTrack.width)
                    )
                }
            }
        }
        
        if let vTrack = mediaVideoTrack {
            completion(.success(vTrack))
        } else {
            completion(.failure(NSError(domain: "mediaGetVideoTrack(), no track", code: 0)))
        }
    }
    
    func mediaGetAudioTrack(mediaId: Int64, completion: @escaping (Result<[MediaAudioTrack], Error>) -> Void) {
        
    }
    
    func mediaGetSubtitleTrack(mediaId: Int64, completion: @escaping (Result<[MediaSubtitleTrack], Error>) -> Void) {
        
    }
    
    func disposeMedia(mediaId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        print("disposeMedia()")
        let mediaWrapper: MediaWrapper? = objectHelper.removeObject(id: mediaId)
        mediaWrapper?.release()
        completion(.success(true))
    }
    
    // MediaPlayer
    func createMediaPlayer(libVlcId: Int64, completion: @escaping (Result<Int64, Error>) -> Void) {
        print("createMediaPlayer()")
        let libVlc: VLCLibrary? = objectHelper.getObject(id: libVlcId)
        if (libVlc == nil) {
            completion(.failure(NSError(domain: "createMediaPlayer(), no found libVlc", code: 0)))
            return
        }
        
        let mediaPlayer = VLCMediaPlayer(library: libVlc!)
        let mediaPlayerWrapper = MediaPlayerWrapper(mediaPlayer: mediaPlayer, flutterApi: flutterApi)
        let mediaPlayerWrapperId = objectHelper.putObject(mediaPlayerWrapper)
        mediaPlayerWrapper.setMediaPlayerWrapperId(mediaPlayerWrapperId: mediaPlayerWrapperId)
        completion(.success(mediaPlayerWrapperId))
    }
    
    func mediaPlayerSetMedia(mediaPlayerId: Int64, mediaId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        print("mediaPlayerSetMedia()")
        let mediaPlayerWrapper: MediaPlayerWrapper? = objectHelper.getObject(id: mediaPlayerId)
        if (mediaPlayerWrapper == nil) {
            completion(.failure(NSError(domain: "mediaPlayerSetMedia(), no found MediaPlayer", code: 0)))
            return
        }
        let mediaWrapper: MediaWrapper? = objectHelper.getObject(id: mediaId)
        if (mediaWrapper == nil) {
            completion(.failure(NSError(domain: "mediaPlayerSetMedia(), no found Media", code: 0)))
            return
        }
        
        let mediaPlayer = mediaPlayerWrapper!.getMediaPlayer()
        let media = mediaWrapper!.getMedia()
        mediaPlayer.media = media
        completion(.success(true))
    }
    
    func mediaPlayerAttachVideoView(mediaPlayerId: Int64, videoViewId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        print("mediaPlayerAttachVideoView()")
        let mediaPlayerWrapper: MediaPlayerWrapper? = objectHelper.getObject(id: mediaPlayerId)
        if (mediaPlayerWrapper == nil) {
            completion(.failure(NSError(domain: "mediaPlayerAttachVideoView(), no found MediaPlayer", code: 0)))
            return
        }
        let videoView: VideoView? = objectHelper.getObject(id: videoViewId)
        if (videoView == nil) {
            completion(.failure(NSError(domain: "mediaPlayerAttachVideoView(), no found VideoView", code: 0)))
            return
        }
        
        let mediaPlayer = mediaPlayerWrapper!.getMediaPlayer()
        let view = videoView!.getView()
        mediaPlayer.drawable = view
        
        completion(.success(true))
    }
    
    func mediaPlayerPlay(mediaPlayerId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        print("mediaPlayerPlay()")
        let mediaPlayerWrapper: MediaPlayerWrapper? = objectHelper.getObject(id: mediaPlayerId)
        let mediaPlayer = mediaPlayerWrapper?.getMediaPlayer()
        mediaPlayer?.play()
        completion(.success(true))
    }
    
    func mediaPlayerPause(mediaPlayerId: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    func mediaPlayerStop(mediaPlayerId: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    func mediaPlayerIsPlaying(mediaPlayerId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func mediaPlayerSetTime(mediaPlayerId: Int64, time: Int64, fast: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    func mediaPlayerGetTime(mediaPlayerId: Int64, completion: @escaping (Result<Int64, Error>) -> Void) {
        
    }
    
    func mediaPlayerSetPosition(mediaPlayerId: Int64, position: Double, fast: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    func mediaPlayerGetPosition(mediaPlayerId: Int64, completion: @escaping (Result<Double, Error>) -> Void) {
        
    }
    
    func mediaPlayerGetLength(mediaPlayerId: Int64, completion: @escaping (Result<Int64, Error>) -> Void) {
        
    }
    
    func mediaPlayerSetVolume(mediaPlayerId: Int64, volume: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    func mediaPlayerGetVolume(mediaPlayerId: Int64, completion: @escaping (Result<Int64, Error>) -> Void) {
        
    }
    
    func mediaPlayerSetRate(mediaPlayerId: Int64, rate: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    func mediaPlayerGetRate(mediaPlayerId: Int64, completion: @escaping (Result<Double, Error>) -> Void) {
        
    }
    
    func disposeMediaPlayer(mediaPlayerId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        print("disposeMediaPlayer()")
        let _: MediaPlayerWrapper? = objectHelper.removeObject(id: mediaPlayerId)
        completion(.success(true))
    }
    
    // VideoView
    func createVideoView(completion: @escaping (Result<VideoViewCreateResult, Error>) -> Void) {
        print("createVideoView()")
        let view = VLCVideoView(frame: CGRectZero)
        view.fillScreen = true
        let videoView = VideoView(view: view)
        let videoViewId = objectHelper.putObject(videoView)
        completion(.success(VideoViewCreateResult(objectId: videoViewId)))
    }
    
    func videoViewSetDefaultBufferSize(videoViewId: Int64, width: Int64, height: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        print("videoViewSetDefaultBufferSize()")
        completion(.success(true))
    }
    
    func disposeVideoView(videoViewId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        print("disposeVideoView()")
        let _: VideoView? = objectHelper.removeObject(id: videoViewId)
        completion(.success(true))
    }
}
