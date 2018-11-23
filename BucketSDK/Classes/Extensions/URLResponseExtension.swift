//
//  URLResponse.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/17/18.
//

import Foundation

public extension Optional where Wrapped == URLResponse {
    var isSuccess: Bool {
        if self.isNil {
            return false
        }
        
        switch self!.code {
        case 200...299:
            return true
        default:
            return false
        }
    }
}

@objc public extension URLResponse {
    @objc var code : Int {
        return (self as! HTTPURLResponse).statusCode
    }
}
