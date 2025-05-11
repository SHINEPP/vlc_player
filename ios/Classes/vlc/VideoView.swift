//
//  VideoView.swift
//  Pods
//
//  Created by zhouzhenliang on 2025/5/11.
//

class VideoView : NSObject {
    
    private let view: UIView
    
    init(view: UIView) {
        self.view = view
        super.init()
    }
    
    func getView() -> UIView {
        return view
    }
}
