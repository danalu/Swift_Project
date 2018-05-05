//
//  ZLDomainManager.swift
//  TestProject
//
//  Created by DanaLu on 2018/4/18.
//  Copyright © 2018年 gh. All rights reserved.
//

import UIKit

enum DomainType: Int {
    case Product = 0    // 生产环境
    case PreProdduct    // 预生产环境
    case Test           // 测试环境
    case Custom         // 自定义域名
}

typealias DomainInfo = (domainType: DomainType, isHttps: Bool, domain: String, port: Int)

class ZLDomainManager: NSObject {
    
    static var currentDomainInfo: DomainInfo {
        return self.getCurrentDomainInfo()
    }
    
    class func getCurrentDomainType() -> DomainType {
        return .Product
    }
    
    class func getFullDomainInfoString() -> String {
        let domainInfo = self.getCurrentDomainInfo()
        var domainString = domainInfo.isHttps ? "https://" : "http://"
        domainString += domainInfo.domain
        if domainInfo.port > 0 {
            domainString += ":\(domainInfo.port)"
        }
        return domainString
    }
    
    class func getCurrentDomainInfo() -> DomainInfo {
        return (domainType: .Product, isHttps: false, domain: "api.dev.eyee.com", port: 80)
    }
    
    class func getDomainModel(domainType type: DomainType) -> DomainInfo? {
        return nil
    }
    
    class func updateDomainInfo(_ domainType: DomainType, domainInfo: DomainInfo) {
        
    }
}
