//
//  ObjectiveCViewController.m
//  BucketSDK_Example
//
//  Created by Ryan Coyne on 4/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import "BucketSDK_Example-Swift.h"
#import "ObjectiveCViewController.h"
#import "ObjectiveCResultViewController.h"
@import BucketSDK;

@interface ObjectiveCViewController ()

@end

@implementation ObjectiveCViewController

NSString *TAG = @"Objective-C BucketSDK";
CreateTransactionResponse *createTransactionResponse;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Check your app's status of being in release or debug.
    // This will make it easier for you as the developer to always make sure you are hitting the Sandbox API rather than the Production API.
    // We suggest doing this in the AppDelegate launch options but we'll place it here for the purposes of this Objective-C demo.
    #if RELEASE
        [Bucket.shared setEnvironment:DeploymentEnvironmentProduction];
    #endif
    
    // You will need to set the retailer id, retailer secret, and terminal id.
    // Credentials.retailerId = @"6644211a-c02a-4413-b307-04a11b16e6a4";
    // Credentials.retailerSecret = @"9IlwMxfQLaOvC4R64GdX/xabpvAA4QBpqb1t8lJ7PTGeR4daLI/bxw==";
    // Credentials.terminalId = @"qwerty1234";
    
    // Now before using the Bucket.shared.bucketAmount(for: entireChangeAmountWithBills), you will need to set your bill denomination.
//    [[Bucket shared] fetchBillDenominationsFor:BillDenominationUsd :^(BOOL success, NSError * _Nullable error) {
//        if (success) {
//            NSLog(@"%@: %@", TAG, @"Bill denominations fetched.");
//        } else if (error != NULL) {
//            NSLog(@"%@: %@", TAG, error.localizedDescription);
//        }
//    }];
    
    // You will need to close the interval for the start-to-end of day.
    //    // No completion.
    //    [[Bucket shared] closeWithIntervalId:@"20180423" :NULL];
    //    // With completion.
    //    [[Bucket shared] closeWithIntervalId:@"20180423" :^(CloseIntervalResponse * _Nullable response, BOOL success, NSError * _Nullable error) {
    //        if (success) {
    //            // Success!!
    //        } else if (error != NULL) {
    //            NSLog(@"%@",error.localizedDescription);
    //        }
    //    }];
    
    [self hideKeyboardWhenTouchedOutside];
}

- (IBAction)createTransaction:(id)sender {
    double totalSale = _textFieldTotalSale.text.doubleValue;
    double cashReceived = _textFieldCashReceived.text.doubleValue;
    
    if (cashReceived > totalSale) {
        double roundedChangeAmount = round(100 * (cashReceived - totalSale)) / 100;
        long bucketAmount = 0; //[[Bucket shared] bucketAmountForDecimal:roundedChangeAmount];
        
        NSLog(@"roundedChangeAmount: %.2f", roundedChangeAmount);
        NSLog(@"bucketAmount: %ld", bucketAmount);
        
        if (bucketAmount > 0) {
            [[Loading shared] show:self.view];
            
            // Now that we have our bucket amount, we can go and create a transaction with that amount, and send it through the Bucket API.
//            Transaction *transaction = [[Transaction alloc] initWithAmount:bucketAmount clientTransactionId:@"YouDecide1234"];
//            [transaction create:^(CreateTransactionResponse *response, BOOL success, NSError * _Nullable error) {
//                [[Loading shared] hide];
//                
//                if (success) {
//                    createTransactionResponse = response;
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self performSegueWithIdentifier: @"goToObjectiveCResult" sender:self];
//                        _textFieldTotalSale.text = nil;
//                        _textFieldCashReceived.text = nil;
//                    });
//                } else if (error != NULL) {
//                    [self showOKAlertWithTitle:@"Error" message:error.localizedDescription];
//                }
//            }];
        } else {
            [self showOKAlertWithTitle:@"Invalid Amount" message:@"Bucket amount results to 0. There is no change to bucket."];
        }
    } else {
        [self showOKAlertWithTitle:@"Invalid Amount" message:@"Cash received must be greater than the total sale amount to bucket the change."];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"goToObjectiveCResult"]) {
        ObjectiveCResultViewController *destinationVC = segue.destinationViewController;
        destinationVC.createTransactionResponse = createTransactionResponse;
    }
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray *arrayOfString = [newString componentsSeparatedByString:@"."];
    
    if ([arrayOfString count] > 2 ) {
        return NO;
    }
    
    return YES;
}

- (void)showOKAlertWithTitle:(NSString*)title
                     message:(NSString*)message {
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
