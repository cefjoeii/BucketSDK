//
//  DeploymentEnvironment.swift
//  BucketSDK
//
//  Created by Ryan Coyne on 4/6/18.
//

@objc public enum DeploymentEnvironment : Int {
    case Production, Development
}

@objc public enum BillDenomination : Int  {
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
