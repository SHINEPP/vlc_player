//
//  VideoView.swift
//  Pods
//
//  Created by zhouzhenliang on 2025/5/11.
//

import Cocoa
import VLCKit

class VideoView : NSObject {
    
    private let view: VLCVideoView
    
    init(view: VLCVideoView) {
        self.view = view
        super.init()
    }
    
    func getView() -> VLCVideoView {
        return view
    }
}
