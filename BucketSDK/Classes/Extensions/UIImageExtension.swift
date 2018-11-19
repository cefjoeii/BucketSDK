//
//  UIImageExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/19/18.
//

import UIKit

@objc public extension UIImage {
    public var asPNG: Data? {
        return UIImagePNGRepresentation(self)
    }
}
