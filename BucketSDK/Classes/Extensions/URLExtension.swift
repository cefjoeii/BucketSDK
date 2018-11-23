//
//  URLExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/17/18.
//

import Foundation

extension URL {
    /// Adds query parameters and set the value to itself. Thus, mutating.
    /// - Parameter queries: The queries to be appended as a `Dictionary`.
    mutating func appendQueriesComponent(_ queries: [String: Any]) {
        self = self.apendingQueriesComponent(queries)
    }
    
    /// Adds query parameters and returns the new URL.
    /// - Parameter queries: The queries to be appended as a `Dictionary`.
    func apendingQueriesComponent(_ queries: [String: Any]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        // Start putting together the paths:
        for query in queries {
            // If the query items is nil, we need to initialize so we can actually add the items.
            if components?.queryItems.isNil == true {
                components?.queryItems = []
            }
            let queryItem = URLQueryItem(name: query.key, value: String(describing: query.value))
            components?.queryItems?.append(queryItem)
        }
        
        if let url = components?.url  {
            return url
        }
        
        return self
    }
}
