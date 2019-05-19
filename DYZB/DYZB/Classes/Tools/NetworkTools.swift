//
//  NetworkTools.swift
//  AlamofireTest
//
//  Created by apple on 2019/05/18.
//  Copyright © 2019年 com.btx. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}

class NetworkTools {
    class func requestData(type : MethodType, URLString : String, parameters: [String : NSString]? = nil, finishedCallback : @escaping (_ result : AnyObject) -> ()) {
        // 1.get type
        let reqType = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        // 2.send http request
        Alamofire.request(URLString, method: reqType, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (response) in
            // 3.get result
            guard let result = response.result.value else{
                print(response.result.error as Any)
                return
            }
            
            // 4.取得結果を回調出去
            finishedCallback(result as AnyObject)
        }
    }

}
