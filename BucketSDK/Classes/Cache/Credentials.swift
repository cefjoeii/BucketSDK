//
//  Credentials.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/19/18.
//

import Foundation
import Strongbox

@objc public class Credentials: NSObject {
    // MARK: - Public(get) Internal(set)
    /// The **retailer code** creating the transaction.
    @objc public static internal(set) var retailerCode: String? {
        get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_RETAILER_CODE") as? String }
        set {
            if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_RETAILER_CODE") }
            else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_RETAILER_CODE") }
        }
    }
    
    /// The **numeric** country id, or the **alpha** two letter country code.
    @objc public static internal(set) var country: String? {
        get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_COUNTRY") as? String }
        set {
            if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_COUNTRY") }
            else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_COUNTRY") }
        }
    }
    
    // MARK: - Internal
    /// The terminal secret of the retailer used to authorize requests with Bucket.
    static var terminalSecret: String? {
        get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_TERMINAL_SECRET") as? String }
        set {
            if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_TERMINAL_SECRET") }
            else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_TERMINAL_SECRET") }
        }
    }
    
    /// The **serial number** of the terminal or device creating the transaction.
    static var terminalCode: String? {
        get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_TERMINAL_CODE") as? String }
        set {
            if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_TERMINAL_CODE") }
            else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_TERMINAL_CODE ") }
        }
    }
}
