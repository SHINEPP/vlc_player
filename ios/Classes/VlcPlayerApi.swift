//
//  VlcPlayerApi.swift
//  Pods
//
//  Created by zhouzhenliang on 2025/5/11.
//


import Flutter
import UIKit
import VLCKit

public class VlcPlayerApi: NSObject, VlcApi {
    
    private let messenger: FlutterBinaryMessenger
    private let objectHelper = ObjectHelper()
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
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
        let libVlc : VLCLibrary? = objectHelper.removeObject(id: libVlcId)
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
            media = VLCMedia(url: URL(string: input.dataSourceValue ?? "")!)
            break
        default:
            break;
        }
        if (media == nil) {
            completion(.failure(NSError(domain: "createMedia", code: 1)))
            return
        }
        let mediaId = objectHelper.putObject(media)
        
        switch(input.hwAcc) {
        case HwAcc.decoding.rawValue:
            media?.addOption(":no-mediacodec-dr")
            media?.addOption(":no-omxil-dr")
            break
        default:
            break;
        }
        
        let options = input.options ?? []
        for option in options {
            media?.addOption(option)
        }
        completion(.success(mediaId))
    }
    
    func setMediaEventListener(mediaId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func mediaParseAsync(mediaId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func mediaGetVideoTrack(mediaId: Int64, completion: @escaping (Result<MediaVideoTrack, Error>) -> Void) {
        
    }
    
    func mediaGetAudioTrack(mediaId: Int64, completion: @escaping (Result<[MediaAudioTrack], Error>) -> Void) {
        
    }
    
    func mediaGetSubtitleTrack(mediaId: Int64, completion: @escaping (Result<[MediaSubtitleTrack], Error>) -> Void) {
        
    }
    
    func disposeMedia(mediaId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    // MediaPlayer
    func createMediaPlayer(libVlcId: Int64, completion: @escaping (Result<Int64, Error>) -> Void) {
        
    }
    
    func mediaPlayerSetMedia(mediaPlayerId: Int64, mediaId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func mediaPlayerAttachVideoView(mediaPlayerId: Int64, videoViewId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func mediaPlayerPlay(mediaPlayerId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        
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
        
    }
    
    // VideoView
    func createVideoView(completion: @escaping (Result<VideoViewCreateResult, Error>) -> Void) {
        
    }
    
    func videoViewSetDefaultBufferSize(videoViewId: Int64, width: Int64, height: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func disposeVideoView(videoViewId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
}
