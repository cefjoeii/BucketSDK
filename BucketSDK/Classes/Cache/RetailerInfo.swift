//
//  RetailerInfo.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/14/18.
//

import Foundation

/// Contains the information about the retailer such as the phone number, adress, and etc.
@objc public class RetailerInfo: NSObject {
    @objc public static internal(set) var retailerName: String? {
        get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_RETAILER_NAME") as? String }
        set {
            if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_RETAILER_NAME") }
            else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_RETAILER_NAME") }
        }
    }
    
    @objc public static internal(set) var retailerPhone: String? {
        get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_RETAILER_PHONE") as? String }
        set {
            if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_RETAILER_PHONE") }
            else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_RETAILER_PHONE") }
        }
    }
    
    @objc public static internal(set) var address1: String? {
        get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_ADDRESS_1") as? String }
        set {
            if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_ADDRESS_1") }
            else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_ADDRESS_1") }
        }
    }
    
    @objc public static internal(set) var address2: String? {
        get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_ADDRESS_2") as? String }
        set {
            if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_ADDRESS_2") }
            else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_ADDRESS_2") }
        }
    }
    
    @objc public static internal(set) var address3: String? {
        get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_ADDRESS_3") as? String }
        set {
            if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_ADDRESS_3") }
            else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_ADDRESS_3") }
        }
    }
    
    @objc public static internal(set) var postalCode: String? {
        get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_POSTAL_CODE") as? String }
        set {
            if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_POSTAL_CODE") }
            else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_POSTAL_CODE") }
        }
    }
    
    @objc public static internal(set) var city: String? {
        get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_CITY") as? String }
        set {
            if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_CITY") }
            else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_CITY") }
        }
    }
    
    @objc public static internal(set) var state: String? {
        get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_STATE") as? String }
        set {
            if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_STATE") }
            else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_STATE") }
        }
    }
}
