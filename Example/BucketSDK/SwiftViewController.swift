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
        
        // For now, you can decide how you are going to store these information.
        Bucket.Credentials.retailerId = "6644211a-c02a-4413-b307-04a11b16e6a4"
        Bucket.Credentials.retailerSecret = "9IlwMxfQLaOvC4R64GdX/xabpvAA4QBpqb1t8lJ7PTGeR4daLI/bxw=="
        Bucket.Credentials.terminalId = "qwerty1234"
        
        // Retrieve the current retailer account details show them up on screen for you as a developer.
        labelRetailerId.text = Bucket.Credentials.retailerId
        labelRetailerSecret.text = Bucket.Credentials.retailerSecret
        labelTerminalId.text = Bucket.Credentials.terminalId
        
        // Now before using the Bucket.shared.bucketAmount(for: entireChangeAmountWithBills), you will need to set your bill denomination.
        Bucket.shared.fetchBillDenominations(.usd) { (success, error) in
            if success {
                print("BucketSDK: billDenominations fetched.")
            } else if error != nil {
                
            }
        }
        
        //        // No completion.
        //        Bucket.shared.close(interval: "20180422")
        //        // With completion.
        //        Bucket.shared.close(interval: "20180422") { (success, error) in
        //            if success {
        //                // Success!!
        //            }
        //            else if !error.isNil {
        //                print(error!.localizedDescription)
        //            }
        //        }
    }
    
    @IBAction func createTransaction(_ sender: Any) {
        showTextFieldAlert(title: "Create Transaction", message: "Enter the entire change amount.", textFieldText: "", keyboardType: .numberPad) { text in
            if let text = text, let amount = Int(text) {
                
                // Create the bucket amount from the total amount of change (in integer format):
                let bucketAmount = Bucket.shared.bucketAmount(for: amount)
                print("BucketSDK: bucketAmount: \(bucketAmount)")
                
                // Now that we have our bucket amount, we can go and create a transaction with that amount, and send it through the Bucket API.
                let transaction = Bucket.Transaction(amount: bucketAmount)
                transaction.create { (success, error) in
                    if success {
                        self.showOKAlert(title: "Transaction Completed", message: "QR Code: \(transaction.qrCodeContent?.absoluteString ?? "")")
                        
                    } else if let error = error {
                        self.showOKAlert(title: "Transaction Failed", message: error.localizedDescription)
                    } else {
                        self.showOKAlert(title: "Ooops", message: "Something went wrong.")
                    }
                }
                
            } else {
                self.showOKAlert(title: "Ooops", message: "Amount is invalid.")
            }
        }
    }
    
    private func showTextFieldAlert(title: String, message: String, textFieldText: String?, keyboardType: UIKeyboardType, completion: @escaping (_ text: String?) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = textFieldText
            textField.keyboardType = keyboardType
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            completion(textField?.text)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    private func showOKAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
