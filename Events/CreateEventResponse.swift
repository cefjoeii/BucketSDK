//
//  CreateEventResponse.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/27/18.
//

import Foundation

@objc public class CreateEventResponse: NSObject, Decodable {
    @objc public let id: Int = -1
    @objc public let result: String?
}
