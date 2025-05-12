//
//  MediaWrapper.swift
//  Pods
//
//  Created by zhouzhenliang on 2025/5/11.
//

import Flutter
import UIKit
import VLCKit

class MediaWrapper : NSObject, VLCMediaDelegate {
    
    private let media: VLCMedia
    private let flutterApi: VlcFlutterApi
    private var mediaId: Int64 = 0
    
    init(media: VLCMedia, flutterApi: VlcFlutterApi) {
        self.media = media
        self.flutterApi = flutterApi
        super.init()
    }
    
    func getMedia() -> VLCMedia {
        return media
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
}
