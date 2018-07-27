//
//  UserDefaultsExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/16/18.
//

import Foundation

public extension UserDefaults {
    
    // This is the denominations of the dollar bills in the register for this retailer.
    internal var denoms: [Int] {
        get {
            return self.array(forKey: "BUCKET_RETAILER_DENOMS") as? [Int] ?? [10000, 5000, 2000, 1000, 500, 200, 100]
        }
        set {
            self.set(newValue, forKey: "BUCKET_RETAILER_DENOMS")
        }
    }
    
    // This indicates whether we should use natural change functions or not.
    internal var usesNaturalChangeFunction: Bool {
        get {
            return self.bool(forKey: "BUCKET_USES_NATURAL_CHANGE")
        }
        set {
            self.set(newValue, forKey: "BUCKET_USES_NATURAL_CHANGE")
        }
    }
}
