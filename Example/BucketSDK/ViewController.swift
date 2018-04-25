//
//  ViewController.swift
//  BucketSDK
//
//  Created by Ryan on 04/06/2018.
//  Copyright (c) 2018 Ryan. All rights reserved.
//

import UIKit
import BucketSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        #if RELEASE
            Bucket.shared.environment = .Production
        #endif
        
//        Bucket.Retailer.logInWith(password: "password", username: "username") { (success, error) in
//            if success {
//                // Yay - we successfully logged in!
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        }
        
        // Create the bucket amount from the total amount of change (in integer format):
        let bucketAmount = Bucket.shared.bucketAmount(for: 7899)
        
        let transaction = Bucket.Transaction(amount: bucketAmount, clientTransactionId: "CKFYGGHPUIGH")
        transaction.create { (success, error) in
            if success {
                // Yay we created the transaction!
                
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
