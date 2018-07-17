//
//  DataExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/17/18.
//

import Foundation

public extension Data {
    var asJSON : [String:Any]? {
        if let theTry = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String:Any] {
            return theTry
        } else {
            return nil
        }
    }
    var bucketError : Error? {
        if let json = self.asJSON {
            if !json["errorCode"].isNil {
                if let message = json["message"] as? String {
                    return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: message])
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
