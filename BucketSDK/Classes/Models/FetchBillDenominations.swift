//
//  FetchBillDenomination.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/20/18.
//

import Foundation

struct FetchBillDenominationsResponse: Decodable {
    
    let currencies: [Currency]?
    
    struct Currency: Decodable {
        let currencyCode: String?
        let numericCode: Int?
        let usesNaturalChangeFunction: Bool?
        let commonDenominations: [Int]?
        let countryCodes: [String]?
        
        init(json: [String: Any]) {
            currencyCode = json["currencyCode"] as? String
            numericCode = json["numericCode"] as? Int
            usesNaturalChangeFunction = json["usesNaturalChangeFunction"] as? Bool
            commonDenominations = json["commonDenominations"] as? [Int]
            countryCodes = json["countryCodes"] as? [String]
        }
    }
}

