//
//  RetailerInfo.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/14/18.
//

import Foundation

@objc public class RetailerInfo: NSObject, NSSecureCoding {
    @objc public let retailerName: String?
    @objc public let retailerPhone: String?
    @objc public let address1: String?
    @objc public let address2: String?
    @objc public let address3: String?
    @objc public let postalCode: String?
    @objc public let city: String?
    @objc public let state: String?
    @objc public let country: String?
    
    init(
        _ retailerName: String?,
        _ retailerPhone: String?,
        _ address1: String?,
        _ address2: String?,
        _ address3: String?,
        _ postalCode: String?,
        _ city: String?,
        _ state: String?,
        _ country: String?
        ) {
        
        self.retailerName = retailerName
        self.retailerPhone = retailerPhone
        self.address1 = address1
        self.address2 = address2
        self.address3 = address3
        self.postalCode = postalCode
        self.city = city
        self.state = state
        self.country = country
    }
    
    // MARK: - NSSecureCoding Protocols
    @objc public static var supportsSecureCoding: Bool {
        return true
    }
    
    @objc public required convenience init?(coder aDecoder: NSCoder) {
        let retailerName = aDecoder.decodeObject(forKey: "BUCKET_RETAILER_NAME") as? String
        let retailerPhone = aDecoder.decodeObject(forKey: "BUCKET_RETAILER_PHONE") as? String
        let address1 = aDecoder.decodeObject(forKey: "BUCKET_ADDRESS_1") as? String
        let address2 = aDecoder.decodeObject(forKey: "BUCKET_ADDRESS_2") as? String
        let address3 = aDecoder.decodeObject(forKey: "BUCKET_ADDRESS_3") as? String
        let postalCode = aDecoder.decodeObject(forKey: "BUCKET_POSTAL_CODE") as? String
        let city = aDecoder.decodeObject(forKey: "BUCKET_CITY") as? String
        let state = aDecoder.decodeObject(forKey: "BUCKET_STATE") as? String
        let countryCode = aDecoder.decodeObject(forKey: "BUCKET_COUNTRY") as? String
        
        self.init(retailerName, retailerPhone, address1, address2, address3, postalCode, city, state, countryCode)
    }
    
    @objc public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.retailerName, forKey: "BUCKET_RETAILER_NAME")
        aCoder.encode(self.retailerPhone, forKey: "BUCKET_RETAILER_PHONE")
        aCoder.encode(self.address1, forKey: "BUCKET_ADDRESS_1")
        aCoder.encode(self.address2, forKey: "BUCKET_ADDRESS_2")
        aCoder.encode(self.address3, forKey: "BUCKET_ADDRESS_3")
        aCoder.encode(self.postalCode, forKey: "BUCKET_POSTAL_CODE")
        aCoder.encode(self.city, forKey: "BUCKET_CITY")
        aCoder.encode(self.state, forKey: "BUCKET_STATE")
        aCoder.encode(self.country, forKey: "BUCKET_COUNTRY")
    }
}
