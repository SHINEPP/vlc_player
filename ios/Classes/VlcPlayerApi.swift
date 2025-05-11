//
//  VlcPlayerApi.swift
//  Pods
//
//  Created by zhouzhenliang on 2025/5/11.
//


import Flutter
import UIKit
import MobileVLCKit

public class VlcPlayerApi: VlcApi {
    
    private let messenger: FlutterBinaryMessenger
    private let objectHelper = ObjectHelper()
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
        VlcApiSetup(self.messenger, self)
    }
    
    #pragma mark - LibVlc
    func createLibVlc(options: [String]?, completion: @escaping (Result<Int64, Error>) -> Void) {
        
        
        
    }
    
    func disposeLibVlc(libVlcId: Int64, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    // Media
    
    // MediaPlayer
    
    // VideoView
}
