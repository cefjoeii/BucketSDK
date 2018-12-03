//
//  Bucket.swift
//  BucketSDK
//
//  Created by Ryan Coyne on 4/6/18.
//

import Foundation
import Strongbox

@objc public class Bucket: NSObject {
    /// A singleton for the shared `Bucket` object.
    @objc public static let shared = Bucket()
    
    /// Sets the environment that defines which endpoint we will hit.
    @objc public dynamic var environment: DeploymentEnvironment = .development
    
    // Instantiate Keychain to store small sensitive information such as the retailerCode and terminalSecret.
    var keychain = Strongbox()

    /// Returns the amount to be bucketed based on the change due back.
    @objc public func bucketAmount(changeDueBack: Double) -> Double {
        var bucketAmount = changeDueBack
        
        var denoms = Terminal.denoms ?? []
        let usesNaturalChangeFunction = Terminal.usesNaturalChangeFunction
        
        if usesNaturalChangeFunction {
            // Make sure this is ordered by the amount.
            denoms.sort(by: >)
            // These values should already be descended from 100.0 down to 1.0
            denoms.forEach { denom in bucketAmount = bucketAmount.truncatingRemainder(dividingBy: denom) }
        } else {
            while bucketAmount > 1.00 { bucketAmount = bucketAmount.truncatingRemainder(dividingBy: 1.00) }
        }
        
        return bucketAmount
    }
}
