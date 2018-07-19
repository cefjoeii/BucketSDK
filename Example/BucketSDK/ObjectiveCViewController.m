//
//  ObjectiveCViewController.m
//  BucketSDK_Example
//
//  Created by Ryan Coyne on 4/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import "ObjectiveCViewController.h"
@import BucketSDK;

@interface ObjectiveCViewController ()

@end

@implementation ObjectiveCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Check your app's status of being in release or debug.
    // This will make it easier for you as the developer to always make sure you are hitting the Sandbox API rather than the Production API.
    // We suggest doing this in the AppDelegate launch options but we'll place it here for the purposes of this Objective-C demo.
    #if RELEASE
        [Bucket.shared setEnvironment: DeploymentEnvironmentProduction];
    #endif
    
    // For now, you can decide how you are going to store these information.
    Credentials.retailerId = @"6644211a-c02a-4413-b307-04a11b16e6a4";
    Credentials.retailerSecret = @"9IlwMxfQLaOvC4R64GdX/xabpvAA4QBpqb1t8lJ7PTGeR4daLI/bxw==";
    Credentials.terminalId = @"qwerty1234";
    
    // Retrieve the current retailer account details show them up on screen for you as a developer.
    _labelRetailerId.text = Credentials.retailerId;
    _labelRetailerSecret.text = Credentials.retailerSecret;
    _labelTerminalId.text = Credentials.terminalId;
    
    // Now before using the Bucket.shared.bucketAmount(for: entireChangeAmountWithBills), you will need to set your bill denomination.
    [[Bucket shared] fetchBillDenominations: BillDenominationUsd completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"BucketSDK: billDenominations fetched.");
        } else if (error != NULL) {
            NSLog(@"BucketSDK: %@", error.localizedDescription);
        }
    }];

    //    // No completion.
    //    [Bucket.shared closeWithInterval:@"20180423" : NULL];
    //    // With completion.
    //    [Bucket.shared closeWithInterval:@"20180423" :^(BOOL success, NSError * _Nullable error) {
    //        if (success) {
    //            // Success!!!!
    //        } else if (error != NULL) {
    //            NSLog(@"%@",error.localizedDescription);
    //        }
    //    }];
}
- (IBAction)createTransation:(id)sender {
    [self showTextFieldAlertWithTitle:@"Create Transaction"
                              message:@"Enter the entire change amount."
                        textFieldText:@""
                         keyboardType:UIKeyboardTypeNumberPad
                           completion:^(NSString *text) {
                               
                               long amount = text.longLongValue;
                               
                               if (amount) {
                                   long bucketAmount = [[Bucket shared] bucketAmountFor:amount];
                                   
                                   Transaction *transaction = [[Transaction alloc] initWithAmount:bucketAmount];
                                   NSLog(@"transaction.intervalId: %@", transaction.intervalId);
                                   [transaction create:^(BOOL success, NSError * _Nullable error) {
                                       if (success) {
                                           // NSLog(t.customerCode, t.bucketTransactionId);
                                           [self showOKAlertWithTitle:@"Transaction Completed" message:[NSString stringWithFormat:@"%@ %@", @"QR Code:", transaction.qrCodeContent]];
                                       } else if (error != NULL) {
                                           [self showOKAlertWithTitle:@"Transaction Failed" message:error.localizedDescription];
                                       } else {
                                           [self showOKAlertWithTitle:@"Ooops" message:@"Something went wrong."];
                                       }
                                   }];
                               } else {
                                   [self showOKAlertWithTitle:@"Ooops" message:@"Amount is invalid."];
                               }
                           }];
}

- (void)showTextFieldAlertWithTitle:(NSString*) title
                            message:(NSString*) message
                      textFieldText:(NSString*) textFieldText
                       keyboardType:(UIKeyboardType) keyboardType
                         completion:(void(^)(NSString*)) completion {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = textFieldText;
        textField.keyboardType = keyboardType;
    }];
    
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         UITextField *textField = alert.textFields[0];
                                                         completion(textField.text);
                                                     }];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showOKAlertWithTitle:(NSString*) title
                     message:(NSString*) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
