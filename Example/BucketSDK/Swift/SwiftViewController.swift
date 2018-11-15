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
    
    let TAG = "Swift BucketSDK"
    
    @IBOutlet weak var textFieldTotalSale: UITextField!
    @IBOutlet weak var textFieldCashReceived: UITextField!
    
    private var createTransactionResponse: CreateTransactionResponse?
    
    override func viewDidLoad() {
        
        // Check your app's status of being in release or debug.
        // This will make it easier for you as the developer to always make sure you are hitting the Sandbox API rather than the Production API.
        // We suggest doing this in the AppDelegate launch options but we'll place it here for the purposes of this Swift demo.
        #if RELEASE
        Bucket.shared.environment = .production
        #endif
        
        // You will need to set the retailer id, retailer secret, and terminal id.
        // Bucket.Credentials.retailerCode = "6644211a-c02a-4413-b307-04a11b16e6a4"
        // Bucket.Credentials.terminalSecret = "9IlwMxfQLaOvC4R64GdX/xabpvAA4QBpqb1t8lJ7PTGeR4daLI/bxw=="
        // Bucket.Credentials.terminalId = "qwerty1234"
        
        // Now before using the Bucket.shared.bucketAmount(for: entireChangeAmountWithBills), you will need to set your bill denomination.
//        Bucket.shared.fetchBillDenominations(for: .usd) { (success, error) in
//            if success {
//                print("\(self.TAG): bill denominations fetched.")
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        }
        
        // You will need to close the interval for the start-to-end of day.
        // No completion.
        //        Bucket.shared.close(intervalId: "20180422")
        //        // With completion.
        //        Bucket.shared.close(intervalId: "20180422") { (response, success, error) in
        //            if success {
        //                // Success!!
        //            } else if let error = error {
        //                print(error.localizedDescription)
        //            }
        //        }
        
        hideKeyboardWhenTouchedOutside()
    }
    
    @IBAction func createTransaction(_ sender: Any) {
        if let totalSale = Double(textFieldTotalSale.text!), let cashReceived = Double(textFieldCashReceived.text!) {
            if cashReceived >= totalSale {
                let roundedChangeAmount = Double(round(100 * (cashReceived - totalSale)) / 100)
                let bucketAmount = 0 // Bucket.shared.bucketAmount(forDecimal: roundedChangeAmount)

                print("\(TAG): roundedChangeAmount: \(String(format: "%.2f", roundedChangeAmount))")
                print("\(TAG): bucketAmount: \(bucketAmount)")
                
                if bucketAmount > 0 {
                    Loading.shared.show(self.view)
                    
                    // Now that we have our bucket amount, we can go and create a transaction with that amount, and send it through the Bucket API.
                    let transaction = Bucket.Transaction(amount: bucketAmount, clientTransactionId: "YouDecide1234")
                    transaction.create { (response, success, error) in
                        Loading.shared.hide()
                        
                        if success {
                            self.createTransactionResponse = response
                            
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "goToSwiftResult", sender: self)
                                self.textFieldTotalSale.text = nil
                                self.textFieldCashReceived.text = nil
                            }
                        } else if let error = error {
                            self.showOKAlert(title: "Error", message: error.localizedDescription)
                        }
                    }
                } else {
                    showOKAlert(title: "Invalid Amount", message: "Bucket amount results to 0. There is no change to bucket.")
                }
            } else {
                showOKAlert(title: "Invalid Amount", message: "Cash received must be greater than the total sale amount to bucket the change.")
            }
        } else {
            showOKAlert(title: "Invalid Amount", message: "Please enter a valid amount in the required fields.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToSwiftResult":
            let destinationVC = segue.destination as! SwiftResultViewController
            destinationVC.createTransactionResponse = self.createTransactionResponse
        default:
            break
        }
    }
    
    private func showOKAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
