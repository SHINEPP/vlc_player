//
//  MediaPlayerWrapper.swift
//  Pods
//
//  Created by zhouzhenliang on 2025/5/11.
//


import FlutterMacOS
import Cocoa
import VLCKit

class MediaPlayerWrapper : NSObject {
    
    private let mediaPlayer: VLCMediaPlayer
    private let flutterApi: VlcFlutterApi
    private var mediaPlayerWrapperId: Int64 = 0
    
    init(mediaPlayer: VLCMediaPlayer, flutterApi: VlcFlutterApi) {
        self.mediaPlayer = mediaPlayer
        self.flutterApi = flutterApi
        super.init()
    }
    
    func getMediaPlayer() -> VLCMediaPlayer {
        return mediaPlayer
    }
    
    func setMediaPlayerWrapperId(mediaPlayerWrapperId: Int64) {
        self.mediaPlayerWrapperId = mediaPlayerWrapperId
    }
}
