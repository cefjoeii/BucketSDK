//
//  DateFormatterExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/16/18.
//

import Foundation

@objc public extension DateFormatter {
    
    public convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
}
