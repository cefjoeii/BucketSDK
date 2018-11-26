//
//  Credentials.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/19/18.
//

import Foundation
import Strongbox

@objc public class Credentials: NSObject {
    // Instantiate Keychain to store small sensitive information such as the retailerCode and terminalSecret.
    private static var keychain = Strongbox()
    
    // MARK: - Public(get) Internal(set)
    /// Contains the information about the retailer such as the phone number, adress, and etc.
    @objc public static internal(set) var retailerInfo: RetailerInfo? {
        get { return self.keychain.unarchive(objectForKey: "BUCKET_RETAILER_INFO") as? RetailerInfo}
        set {
            if newValue.isNil { self.keychain.remove(key: "BUCKET_RETAILER_INFO") }
            else { _ = self.keychain.archive(newValue!, key: "BUCKET_RETAILER_INFO") }
        }
    }
    
    /// The **retailer code** creating the transaction.
    @objc public static internal(set) var retailerCode: String? {
        get { return self.keychain.unarchive(objectForKey: "BUCKET_RETAILER_CODE") as? String }
        set {
            if newValue.isNil { self.keychain.remove(key: "BUCKET_RETAILER_CODE") }
            else { _ = self.keychain.archive(newValue!, key: "BUCKET_RETAILER_CODE") }
        }
    }
    
    
    // MARK: - Internal
    /// The terminal secret of the retailer used to authorize requests with Bucket.
    static var terminalSecret: String? {
        get { return self.keychain.unarchive(objectForKey: "BUCKET_TERMINAL_SECRET") as? String }
        set {
            if newValue.isNil { self.keychain.remove(key: "BUCKET_TERMINAL_SECRET") }
            else { _ = self.keychain.archive(newValue!, key: "BUCKET_TERMINAL_SECRET") }
        }
    }
    
    /// The **serial number** of the terminal or device creating the transaction.
    static var terminalCode: String? {
        get { return self.keychain.unarchive(objectForKey: "BUCKET_TERMINAL_ID") as? String }
        set {
            if newValue.isNil { self.keychain.remove(key: "BUCKET_TERMINAL_ID") }
            else { _ = self.keychain.archive(newValue!, key: "BUCKET_TERMINAL_ID") }
        }
    }
    
    static var isApproved: Bool {
        get {
            return self.keychain.unarchive(objectForKey: "BUCKET_IS_APPROVED") as? Bool ?? false
        }
        set {
            _ = self.keychain.archive(newValue, key: "BUCKET_IS_APPROVED")
        }
    }
    
    static var requireEmployeeCode: Bool {
        get {
            return self.keychain.unarchive(objectForKey: "BUCKET_REQUIRE_EMPLOYEE_CODE") as? Bool ?? false
        }
        set {
            _ = self.keychain.archive(newValue, key: "BUCKET_REQUIRE_EMPLOYEE_CODE")
        }
    }

    static var usesNaturalChangeFunction: Bool {
        get {
            return self.keychain.unarchive(objectForKey: "BUCKET_USES_NATURAL_CHANGE") as? Bool ?? false
        }
        set {
            _ = self.keychain.archive(newValue, key: "BUCKET_USES_NATURAL_CHANGE")
        }
    }
    
    static var denoms: [Double]? {
        get {
            return self.keychain.unarchive(objectForKey: "BUCKET_DENOMS") as? [Double]
        }
        set {
            if newValue.isNil { self.keychain.remove(key: "BUCKET_DENOMS") }
            _ = self.keychain.archive(newValue, key: "BUCKET_DENOMS")
        }
    }
}
