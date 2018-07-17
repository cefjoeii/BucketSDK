//
//  DictionaryExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/16/18.
//

import Foundation

extension Dictionary {
    
    var data : Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
    
    var prettyPrint : String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            
            // Now lets cast this back into a string
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
