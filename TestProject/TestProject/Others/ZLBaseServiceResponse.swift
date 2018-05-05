//
//  ZLBaseServiceResponse.swift
//  TestProject
//
//  Created by DanaLu on 2018/4/20.
//  Copyright © 2018年 gh. All rights reserved.
//

import UIKit

enum APIStatusCode:Int {
    case Success = 1511200
    case InvalidToken = 1511540
    case ExpiredToken = 1511541
    case LogigOnOther = 1511542
    case NeedLogin = 1511545
}


extension APIStatusCode: CustomStringConvertible {
    var description: String {
        switch self {
        case .Success:
            return "sucess"
        case .InvalidToken:
            return "无效的身份令牌"
        case .ExpiredToken:
            return "秘钥已过期"
        case .LogigOnOther:
            return "在其他设备登录"
        case .NeedLogin:
            return "未登录,请登录再试"
        }
    }
}

public protocol CustomNSError : Error {
    /// The domain of the error.
    var errorDomain: String? { get }
    /// The error code within the given domain.
    var errorCode: Int { get }
    /// The user-info dictionary.
    var message: String? { get }
}

struct CustomError: CustomNSError {
    var errorDomain: String?
    var errorCode: Int
    var errorMessage: String? {
        get {
            if let errorm = APIStatusCode.init(rawValue: errorCode)?.description {
                return errorm
            }
            return self.message
        }
    }
    var message: String?
}

class ZLBaseServiceResponse: NSObject {
    var statusCode: APIStatusCode?
    var parsingError: CustomError?
    var serverTimeString: String?
    var responseContent: Any?
    var apiExpiretime: Int64?
    var isSuccessful: Bool = false
    
    init(responseObject json:Dictionary<String, Any>?) {
        guard let _ = json else {
            return
        }
        
        if let code:Int = json!["code"] as? Int {
            self.statusCode = APIStatusCode.init(rawValue: code)
        }
        
        if self.statusCode != .Success {
            if let errormessage = json!["msg"] as? String {
                self.parsingError = CustomError.init(errorDomain: NSURLErrorDomain, errorCode: (self.statusCode?.rawValue)!, message: errormessage)
            } else {
                self.parsingError = CustomError.init(errorDomain: NSURLErrorDomain, errorCode: (self.statusCode?.rawValue)!, message: nil)
            }
            return
        }
        
        if let serverTime: String = json!["servertime"] as? String {
            self.serverTimeString = serverTime
        }
        
        if let content = json!["data"] {
            self.responseContent = content
        }
        
        if let expiretime = json!["expiretime"] as? Int64 {
            self.apiExpiretime = expiretime
        }
    }
}
