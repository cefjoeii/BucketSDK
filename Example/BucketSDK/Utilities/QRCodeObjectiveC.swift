//
//  QRCodeObjectiveC.swift
//  BucketSDK_Example
//
//  Created by Ceferino Jose II on 7/24/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import QRCode

@objc class QRCodeObjectiveC: NSObject {
    
    @objc class func generateQRCodeImage(with url: URL?) -> UIImage? {
        var image: UIImage?
        
        if let url = url {
            image = QRCode(url)?.image
        }
        
        return image
    }
}
