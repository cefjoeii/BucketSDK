//
//  CreateEventResponse.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/27/18.
//

import Foundation

@objc public class CreateEventResponse: NSObject, Decodable {
    let id: Int?
    let result: String?
}
