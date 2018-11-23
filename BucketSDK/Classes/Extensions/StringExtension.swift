//
//  StringExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/19/18.
//

import Foundation

extension String {
    var asQrCode: UIImage? {
        let data = self.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    var isValidStartEndDate: Bool {
        let dateFormatter = DateFormatter(format: "yyyy-MM-dd HH:m:ssZZZ")   
        if let _ = dateFormatter.date(from: self) { return true } else { return false }
    }
    
    var isNotValidStartEndDate: Bool { return !self.isValidStartEndDate }
    
    var isValidDayDate: Bool {
        let dateFormatter = DateFormatter(format: "yyyy-MM-dd")
        if let _ = dateFormatter.date(from: self) { return true } else { return false }
    }
    
    var isNotValidDayDate: Bool { return !self.isValidDayDate }
}
