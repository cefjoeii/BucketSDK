//
//  URLExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/17/18.
//

import Foundation

extension URL {
    static var closeInterval: URL = Bucket.shared.environment.url.appendingPathComponent("closeinterval")
    static var createTransaction: URL = Bucket.shared.environment.url.appendingPathComponent("transaction")
    
    // This URL for the bill denominations does not change between development and production. We default to USD.
    static var billDenominations = URL(string: "https://bucketresources.blob.core.windows.net/static/Currencies.json")!
    
    // Add query parameters and set the value to itself. Thus, mutating.
    public mutating func addQueryParams(_ queryParams: [String: Any]) {
        self = self.addingQueryParams(queryParams)
    }
    
    // Add query parameters to your URL object using a dictionary and return.
    public func addingQueryParams(_ queryParams: [String: Any]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        // Start putting together the paths:
        for param in queryParams {
            // If the query items is nil, we need to initialize so we can actually add the items.
            if components?.queryItems.isNil == true {
                components?.queryItems = []
            }
            let queryItem = URLQueryItem(name: param.key, value: String(describing: param.value))
            components?.queryItems?.append(queryItem)
        }
        
        if let url = components?.url  {
            return url
        }
        
        return self
    }
}
