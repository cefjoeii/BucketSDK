//
//  DeploymentEnvironment.swift
//  BucketSDK
//
//  Created by Ryan Coyne on 4/6/18.
//

@objc public enum DeploymentEnvironment: Int {
    case development, staging, production
    
    var url: URL {
        let version = "v1"
        
        switch self {
        case .development:
            return URL(string: "https://dev.bucketthechange.com/api/\(version)")!
        case .staging:
            return URL(string: "https://staging.bucketthechange.com/api/\(version)")!
        case .production:
            return URL(string: "https://prod.bucketthechange.com/api/\(version)")!
        }
    }
}
