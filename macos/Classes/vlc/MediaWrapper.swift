//
//  MediaWrapper.swift
//  Pods
//
//  Created by zhouzhenliang on 2025/5/11.
//

import FlutterMacOS
import Cocoa
import VLCKit

class MediaWrapper : NSObject, VLCMediaDelegate {
    
    private let media: VLCMedia
    private let libVlcId: Int64
    private let flutterApi: VlcFlutterApi
    private var mediaId: Int64 = 0
    
    init(media: VLCMedia, libVlcId:Int64, flutterApi: VlcFlutterApi) {
        self.media = media
        self.libVlcId = libVlcId
        self.flutterApi = flutterApi
        super.init()
    }
    
    func getMedia() -> VLCMedia {
        return media
    }
    
    func getLibVlcId() -> Int64 {
        return libVlcId
    }
    
    func setMediaId(mediaId: Int64) {
        self.mediaId = mediaId
    }
    
    func setMediaEventListener() {
        media.delegate = self
    }
    
    func mediaMetaDataDidChange(_ aMedia: VLCMedia) {
        DispatchQueue.main.async {
            self.flutterApi.onMediaEvent(mediaId: self.mediaId, event: MediaEvent.META_CHANGED.rawValue) { result in
                switch result {
                case .success(let value):
                    print("Media event sent successfully: \(value)")
                case .failure(let error):
                    print("Failed to send media event: \(error)")
                }
            }
        }
    }

    func mediaDidFinishParsing(_ aMedia: VLCMedia) {
        DispatchQueue.main.async {
            self.flutterApi.onMediaEvent(mediaId: self.mediaId, event: MediaEvent.PARSED_CHANGED.rawValue) { result in
                switch result {
                case .success(let value):
                    print("Media event sent successfully: \(value)")
                case .failure(let error):
                    print("Failed to send media event: \(error)")
                }
            }
        }
    }
    
    func release() {
        media.delegate = self
    }
}
