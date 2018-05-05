//
//  TestTwo.swift
//  OCBridgeSwift
//
//  Created by DanaLu on 2018/4/27.
//  Copyright © 2018年 gh. All rights reserved.
//

import UIKit

public class TestTwo: NSObject {
    var items: [Int] = []
     func push(_ item: Int) {
        items.append(item)
    }
    
     func pop() {
        items.removeLast()
    }
    
    subscript(i: Int) -> Int {
        get {
            return items[i]
        }
    }
    
    static func test() {
        do {
            try testThrow()
        } catch  {
            if let e = error as? NSError {
                print(e)
            }
        }
    }
    
    static func testThrow() throws {
        print("test")
        
        throw NSError(domain: "testErrorDomain", code: 1000, userInfo: ["testKey": "value"])
    }
}
