//
//  SwiftViewController.swift
//  BucketSDK_Example
//
//  Created by Ceferino Jose II on 7/17/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import BucketSDK

class SwiftViewController: UIViewController {
    
    @IBOutlet weak var labelRetailerId: UILabel!
    @IBOutlet weak var labelRetailerSecret: UILabel!
    @IBOutlet weak var labelTerminalId: UILabel!
    
    override func viewDidLoad() {
        
        // Check your app's status of being in release or debug.
        // This will make it easier for you as the developer to always make sure you are hitting the Sandbox API rather than the Production API.
        // We suggest doing this in the AppDelegate launch options but we'll place it here for the purposes of this Swift demo.
        #if RELEASE
            Bucket.shared.environment = .production
        #endif
        
        // Retrieve the current retailer account details
        labelRetailerId.text = Bucket.Credentials.retailerId
        labelRetailerSecret.text = Bucket.Credentials.retailerSecret

    }
    
    @IBAction func editRetailerId(_ sender: Any) {
        showTextFieldAlert(title: "Retailer ID", message: "", textFieldText: labelRetailerId.text) { text in
            self.labelRetailerId.text = text
            Bucket.Credentials.retailerId = text
        }
    }
    
    @IBAction func editRetailerSecret(_ sender: Any) {
        showTextFieldAlert(title: "Retailer Secret", message: "", textFieldText: labelRetailerId.text) { text in
            self.labelRetailerSecret.text = text
            Bucket.Credentials.retailerSecret = text
        }
    }
    
    @IBAction func registerTerminal(_ sender: Any) {
        
    }
    
    
    func showTextFieldAlert(title: String, message: String, textFieldText: String?, completion: @escaping (_ text: String?) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = textFieldText
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            completion(textField?.text)
        }))

        self.present(alert, animated: true, completion: nil)
    }
}
