//
//  URLExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/17/18.
//

import Foundation

extension URL {
    struct Retail {
        static var base : URL {
            switch Bucket.shared.environment {
            case .Production:
                return URL(string: "https://bucketthechange.com/api")!
            case .Development:
                return URL(string: "https://sandboxretailerapi.bucketthechange.com/api")!
            }
        }
        static var billDenominations : URL {
            return URL(string: "https://bucketresources.blob.core.windows.net/static/Currencies.json")!
        }
    }
    struct Transaction {
        static var base : URL {
            switch Bucket.shared.environment {
            case .Production:
                return URL(string: "https://bucketthechange.com/api")!
            case .Development:
                return URL(string: "https://sandboxretailerapi.bucketthechange.com/api")!
            }
        }
    }
    struct close {
        static var interval : URL {
            switch Bucket.shared.environment {
            case .Production:
                return URL(string: "https://bucketthechange.com/api")!
            case .Development:
                return URL(string: "https://sandboxretailerapi.bucketthechange.com/api")!
            }
        }
    }
    
    // Add query parameters to your URL object using a dictionary.
    public mutating func addQueryParams(_ queryParams : [String:Any]) {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        // Start putting together the paths:
        for param in queryParams {
            // If the query items is nil, we need to initialize so we can actually add the items:
            if components?.queryItems.isNil  == true {
                components?.queryItems = []
            }
            let queryItem = URLQueryItem(name: param.key, value: String(describing: param.value))
            components?.queryItems?.append(queryItem)
        }
        
        if let url = components?.url  {
            self = url
        }
    }
}
