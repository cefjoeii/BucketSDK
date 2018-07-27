//
//  URLRequestExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/16/18.
//

import Foundation

extension URLRequest {
    
    mutating func setMethod(_ method: HTTPMethod) {
        self.httpMethod = method.rawValue
    }
    
    mutating func setBody(_ json : [String:Any]) {
        self.httpBody = json.data
    }
}
