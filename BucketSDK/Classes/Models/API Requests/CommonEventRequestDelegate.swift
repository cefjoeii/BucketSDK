//
//  CommonEventRequestDelegate.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/26/18.
//

import Foundation

protocol CommonEventRequestDelegate {
    var range: [String: Any] { get }
    var eventName: String { get }
    var eventMessage: String { get }
    var body: [String: Any] { get }
}
