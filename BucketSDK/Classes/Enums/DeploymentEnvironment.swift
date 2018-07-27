//
//  DeploymentEnvironment.swift
//  BucketSDK
//
//  Created by Ryan Coyne on 4/6/18.
//

@objc public enum DeploymentEnvironment: Int {
    case production, development
    
    var url: URL {
        switch self {
        case .production:
            return URL(string: "https://bucketthechange.com/api")!
        case .development:
            return URL(string: "https://sandboxretailerapi.bucketthechange.com/api")!
        }
    }
}
