//
//  URLRequestExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/16/18.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST", put = "PUT", patch = "PATCH", delete = "DELETE", get = "GET"
}

extension URLRequest {
    mutating func setMethod(_ method: HTTPMethod) {
        self.httpMethod = method.rawValue
    }
    
    mutating func setBody(_ json: [String: Any]) {
        self.httpBody = json.data
    }
    
    mutating func setHeaders(_ headers: [String: String]) {
        self.allHTTPHeaderFields = headers
    }
    
    mutating func addHeader(_ key: String, _ value: String) {
        self.addValue(value, forHTTPHeaderField: key)
    }
}
