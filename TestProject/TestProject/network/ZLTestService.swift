//
//  ZLTestService.swift
//  TestProject
//
//  Created by DanaLu on 2018/4/24.
//  Copyright © 2018年 gh. All rights reserved.
//

import UIKit

typealias ParametersBlock = ((_ parameters: Dictionary<String, Any>) ->())?
typealias ResultResponse = (_ result: Any?, _ error: CustomError?) ->()

class ZLTestService: NSObject {
    class func requestTestInfo(_ requestType: NetworkRequestType,
                               parameter: ParametersBlock,
                               response: @escaping ResultResponse) {
        ZLHttpBaseService.sendRequest(requestType: .get, path: "api/auth/open/token", parametersBlock: nil, taskBlock: nil) { (responseContent, error) in
            guard responseContent != nil else {
                response(nil, error)
                return
            }
            
            if let dic = responseContent as? Dictionary<String, Any> {
                let token = dic["token"] as? String
                response(token, nil)
            } else {
                response(responseContent, error)
            }
        }
    }
}
