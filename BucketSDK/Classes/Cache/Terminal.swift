//
//  Terminal.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 12/3/18.
//

import Foundation

/// Manages the attributes regarding the terminal.
@objc public class Terminal: NSObject {
    static var isApproved: Bool {
        get {
            return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_IS_APPROVED") as? Bool ?? false
        }
        set {
            _ = Bucket.shared.keychain.archive(newValue, key: "BUCKET_IS_APPROVED")
        }
    }
    
    /// This indicates whether or not you need to send in the employeeCode for transaction requests.
    static var requireEmployeeCode: Bool {
        get {
            return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_REQUIRE_EMPLOYEE_CODE") as? Bool ?? false
        }
        set {
            _ = Bucket.shared.keychain.archive(newValue, key: "BUCKET_REQUIRE_EMPLOYEE_CODE")
        }
    }
    
    static var usesNaturalChangeFunction: Bool {
        get {
            return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_USES_NATURAL_CHANGE") as? Bool ?? false
        }
        set {
            _ = Bucket.shared.keychain.archive(newValue, key: "BUCKET_USES_NATURAL_CHANGE")
        }
    }
    
    static var denoms: [Double]? {
        get {
            return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_DENOMS") as? [Double]
        }
        set {
            if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_DENOMS") }
            _ = Bucket.shared.keychain.archive(newValue, key: "BUCKET_DENOMS")
        }
    }
}
