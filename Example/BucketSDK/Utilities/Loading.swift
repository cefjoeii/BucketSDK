//
//  Loading.swift
//  BucketSDK_Example
//
//  Created by Ceferino Jose II on 7/23/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

public class Loading {
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: Loading {
        struct Static {
            static let instance: Loading = Loading()
        }
        return Static.instance
    }
    
    public func show(_ view: UIView) {
        DispatchQueue.main.async {
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            self.activityIndicator.activityIndicatorViewStyle = .whiteLarge
            self.activityIndicator.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            self.activityIndicator.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
            view.addSubview(self.activityIndicator)
            
            self.activityIndicator.startAnimating()
        }
    }
    
    public func hide() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}
