//
//  UIViewControllerExtension.swift
//  BucketSDK_Example
//
//  Created by Ceferino Jose II on 7/23/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

extension UIViewController {
    @objc func hideKeyboardWhenTouchedOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
