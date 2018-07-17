//
//  UserDefaultsExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/16/18.
//

import Foundation

public extension UserDefaults {
    
    internal var denominations : [Int]? {
        get {
            return self.array(forKey: "BUCKET_RETAILER_DENOMS") as? [Int]
        }
        set {
            self.set(newValue, forKey: "BUCKET_RETAILER_DENOMS")
        }
    }
}
