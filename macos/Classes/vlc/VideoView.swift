//
//  VideoView.swift
//  Pods
//
//  Created by zhouzhenliang on 2025/5/11.
//

class VideoView : NSObject {
    
    private let view: NSView
    
    init(view: NSView) {
        self.view = view
        super.init()
    }
    
    func getView() -> NSView {
        return view
    }
}
