//
//  ZLHttpBaseService.swift
//  TestProject
//
//  Created by DanaLu on 2018/4/17.
//  Copyright © 2018年 gh. All rights reserved.
//

import UIKit
import AFNetworking

enum NetworkRequestType {
    case post
    case get
}

typealias responseBlock = (_ result: Any?, _ error: CustomError?) ->()

class ZLHttpBaseService: AFHTTPSessionManager {
    static let shareHttpSessionInstance:ZLHttpBaseService = {
        let sessionManager = ZLHttpBaseService()
        sessionManager.requestSerializer = AFJSONRequestSerializer()
        sessionManager.requestSerializer.timeoutInterval = 15.0;
        sessionManager.requestSerializer.stringEncoding = String.Encoding.utf8.rawValue
        
        let securitePolicy = AFSecurityPolicy.init(pinningMode: AFSSLPinningMode.none)
        securitePolicy.allowInvalidCertificates = true
        securitePolicy.validatesDomainName = false
        sessionManager.securityPolicy = securitePolicy
        
        sessionManager.responseSerializer = AFJSONResponseSerializer()
        sessionManager.responseSerializer.acceptableContentTypes = NSSet.init(objects: "application/json", "text/plain", "text/javascript", "text/json", "text/html", "text/json") as? Set<String>

        return sessionManager
    }()
    
    class func sendRequest(requestType: NetworkRequestType,
                     path: String,
                     parametersBlock: ((_ parameterDic: Dictionary<String, Any>) ->())?,
                     taskBlock: ((_ task: URLSessionDataTask) ->())?,
                     response:@escaping responseBlock) {
        var urlPath = ZLDomainManager.getFullDomainInfoString()
        urlPath += "/" + path
        let parameterDic: [String: Any] = Dictionary()
        if parametersBlock != nil {
            parametersBlock!(parameterDic)
        }
        
        let manager = self.shareHttpSessionInstance
        manager.requestSerializer.setValue(self.getUserToken(), forHTTPHeaderField: "authorization")
        var task: URLSessionDataTask!
        
        // 成功闭包
        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
            operateRequestResult(responseObj, urlPath: urlPath, parameters: parameterDic, error: nil, response: response)
        }
        
        // 失败的闭包
        let failureBlock = { (task: URLSessionDataTask?, error: Error) in
            operateRequestResult(nil, urlPath: urlPath, parameters: parameterDic, error: error, response: response)
        }
        
        switch requestType {
        case .get:
            task = manager.get(urlPath, parameters: parameterDic, progress: nil, success: successBlock, failure: failureBlock)
        case .post:
            task = manager.post(urlPath, parameters: parameterDic, progress: nil, success: successBlock, failure: failureBlock)
        }
        
        if taskBlock != nil {
            taskBlock!(task)
        }
    }
    
    // MARK: tool
    class func getUserToken() -> String {
        let userToken = "cfW6qB%2FeThPinl%2F0AzCEMgF3fSeeks74jY9xGd0ZUz%2FgqVkue8406lovupRAXgW2fJlZ9%2Ft63w4DLHseXl15SqqnWRTCjqEEUFWzDdtzH93KzJKkmHsojP7JX%2FN%2Fq%2BjDDVH3T8o62alRj3rA08FeaIcYAT2txvm%2B"
//        return "Bearer " + userToken
        return userToken
    }
    
    class func operateRequestResult(_ responseObj: Any?,
                                    urlPath: String,
                                    parameters: Dictionary<String, Any>?,
                                    error: Error?,
                                    response:@escaping responseBlock) {
        guard (((responseObj as? Dictionary<String, Any>) != nil) && error == nil) else {
            let nsError = error as? NSError
            let customError = CustomError.init(errorDomain: nsError?.domain, errorCode: (nsError?.code)!, message: nil)
            response(nil, customError)
            return
        }
        
        let serviceResponse = ZLBaseServiceResponse.init(responseObject: responseObj as? Dictionary<String, Any>)
        if (serviceResponse.parsingError != nil) {
            self.checkRequestIsValid(serviceResponse.statusCode!)
        }
        
        DispatchQueue.main.async() {
            response(serviceResponse.responseContent, serviceResponse.parsingError)
        }
    }
    
    class func checkRequestIsValid(_ statusCode: APIStatusCode) {
        var shouldLogout: Bool = false
        switch statusCode {
        case .InvalidToken:
            shouldLogout = true
        case .ExpiredToken:
            shouldLogout = true
        case .LogigOnOther:
            shouldLogout = true
        case .NeedLogin:
            shouldLogout = true
        default:
            shouldLogout = false
        }
        
        if (shouldLogout) {
            //logout.
        }
    }
}
