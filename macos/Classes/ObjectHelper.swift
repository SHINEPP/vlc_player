//
//  ObjectHelper.swift
//  Pods
//
//  Created by zhouzhenliang on 2025/5/11.
//

import Foundation

class ObjectHelper {
    private static var vlcId: Int64 = 0
    private static let idLock = NSLock()
    
    private var vlcObjects = [Int64: Any]()
    
    func putObject(_ object: Any) -> Int64 {
        ObjectHelper.idLock.lock()
        ObjectHelper.vlcId += 1
        let id = ObjectHelper.vlcId
        ObjectHelper.idLock.unlock()
        
        vlcObjects[id] = object
        return id
    }

    func getObject<T>(id: Int64) -> T? {
        return vlcObjects[id] as? T
    }

    func removeObject<T>(id: Int64) -> T? {
        return vlcObjects.removeValue(forKey: id) as? T
    }
}

