//
//  RegisterTerminalResponse.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/20/18.
//

import Foundation

struct RegisterTerminalResponse: Decodable {
    let isApproved: Bool?
    let apiKey: String?
    let retailerName: String?
    let retailerPhone: String?
    let address: Address?

    struct Address: Decodable {
        let address1: String?
        let address2: String?
        let address3: String?
        let postalCode: String?
        let city: String?
        let state: String?
    }
}
