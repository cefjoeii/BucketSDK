//
//  DataExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/17/18.
//

import Foundation

extension Data {
    var asJSON: [String: Any]? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any] {
            return json
        } else {
            return nil
        }
    }
}
