//
//  OptionalExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/16/18.
//

import Foundation

public extension Optional {
    
    // Check the value of the object and return true if the value is nil or false if not.
    public var isNil: Bool {
        return self == nil
    }
    
    // Reverse the result of isNil so it feels more natural to write than using the exclamation point.
    public var isNotNil: Bool {
        return !self.isNil
    }
    
    public var stringValue: String? {
        if self.isNil {
            return nil
        }
        
        switch self {
        case is String, is String?:
            return self as? String
        default:
            return nil
        }
    }
    
    public var urlValue: URL? {
        if self.isNil {
            return nil
        }
        
        switch self {
        case is String, is String?:
            return URL(string: self as! String)
        default:
            return nil
        }
    }
    
    public var intValue: Int? {
        if self.isNil {
            return nil
        }
        
        switch self {
        case is Int, is Int?:
            return self as? Int
        default:
            return nil
        }
    }
}
