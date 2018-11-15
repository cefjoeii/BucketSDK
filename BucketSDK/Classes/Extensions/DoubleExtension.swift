//
//  DoubleExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/15/18.
//

extension Double {
    /// Updates the decimal places of the double.
    /// - Parameter precision: Defaults to 2.
    @discardableResult mutating func updateDecimalPlaces(to precision: Int = 2) -> Double {
        self = Double(String(format: "%.\(precision)f", self))!
        return self
    }
}
