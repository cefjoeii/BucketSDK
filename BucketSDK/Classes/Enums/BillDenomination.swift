//
//  BillDenomination.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/17/18.
//

import Foundation

@objc public enum BillDenomination : Int {
    case usd, sgd
    
    var stringValue : String {
        switch self {
        case .usd:
            return "USD"
        case .sgd:
            return "SGD"
        }
    }
}
