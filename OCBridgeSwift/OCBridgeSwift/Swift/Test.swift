//
//  Test.swift
//  OCBridgeSwift
//
//  Created by DanaLu on 2018/4/27.
//  Copyright © 2018年 gh. All rights reserved.
//

import UIKit

public class Test<T>: NSObject {
    var items: [T] = []
    func push(_ item: T) {
        items.append(item)
    }
    
    func pop() {
        items.removeLast()
    }
    
    subscript(i: Int) -> T {
        get {
            return items[i]
        }
    }
}
