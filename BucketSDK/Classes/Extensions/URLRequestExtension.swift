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
    
    @discardableResult mutating func authenticate(
        _ retailerCode: String?,
        _ terminalCode: String?,
        _ country: String?,
        _ terminalSecret: String?
        ) -> (success: Bool, error: Error?) {
        
        guard let retailerCode = retailerCode, let terminalSecret = terminalSecret else {
            return (false, BucketErrorResponse.invalidRetailer)
        }
        
        guard let terminalCode = terminalCode else {
            return (false, BucketErrorResponse.noTerminalId)
        }
        
        guard let country = country else {
            return (false, BucketErrorResponse.invalidCountryCode)
        }
        
        self.setHeaders([
            "retailerCode": retailerCode,
            "terminalCode": terminalCode,
            "country": country,
            "x-functions-key": terminalSecret
        ])
        
        return (true, nil)
    }
}
