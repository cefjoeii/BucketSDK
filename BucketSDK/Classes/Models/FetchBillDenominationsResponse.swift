//
//  FetchBillDenominationsResponse.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/20/18.
//

import Foundation

struct FetchBillDenominationsResponse: Decodable {
    let usesNaturalChangeFunction: Bool?
    let denominations: [Double]?
}

