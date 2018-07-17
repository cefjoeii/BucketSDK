//
//  MainViewController.swift
//  BucketSDK
//
//  Created by Ryan on 04/06/2018.
//  Copyright (c) 2018 Ryan. All rights reserved.
//

import UIKit
import BucketSDK

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        #if RELEASE
//            Bucket.shared.environment = .production
//        #endif
//        
//        Bucket.Credentials.retailerId = "6644211a-c02a-4413-b307-04a11b16e6a4"
//        Bucket.Credentials.retailerSecret = "9IlwMxfQLaOvC4R64GdX/xabpvAA4QBpqb1t8lJ7PTGeR4daLI/bxw=="
//        
//        // Create the bucket amount from the total amount of change (in integer format):
//        let bucketAmount = Bucket.shared.bucketAmount(for: 7899)
//        
//        let transaction = Bucket.Transaction(amount: bucketAmount, clientTransactionId: "CKFYGGHPUIGH", totalAmount: 5000)
//        transaction.terminalId = "C030UQ71150503"
//        transaction.create { (success, error) in
//            if success {
//                // Yay we created the transaction!
//                print("Yay we created the transaction!")
//                
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        }
//        
//        // Close an interval:
//        Bucket.shared.close(interval: "20180422")
//        // OR use the callback:
//        Bucket.shared.close(interval: "20180422") { (success, error) in
//            if success {
//                // Success!!
//            }
//            else if !error.isNil {
//                print(error!.localizedDescription)
//            }
//        }
        
    }
}
