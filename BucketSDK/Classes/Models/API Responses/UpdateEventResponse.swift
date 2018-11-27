//
//  UpdateEventResponse.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/27/18.
//

import Foundation

@objc public class UpdateEventResponse: NSObject, Decodable {
    let id: Int?
    let result: String?
}
