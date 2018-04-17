//
//  AnotherViewController.m
//  BucketSDK_Example
//
//  Created by Ryan Coyne on 4/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import "AnotherViewController.h"
@import BucketSDK;

@interface AnotherViewController ()

@end

@implementation AnotherViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set your environment (this points your requests to either the Sandbox API or the Production API.
    #if RELEASE
        [Bucket.shared setEnvironment: DeploymentEnvironmentProduction];
    #endif
    
//    [Retailer logInWithPassword:@"password" username:@"username" :^(BOOL success, NSError * _Nullable error) {
//        if (success) {
//
//        } else if (error != NULL) {
//            NSLog(@"%@", error.localizedDescription);
//        }
//    }];
    
    long bucketAmount = [[Bucket shared] bucketAmountFor:7999];
//
//    Transaction *t = [[Transaction alloc] initWithAmount:bucketAmount clientTransactionId:@"ZDFRPHGYKOUG"];
//    [t create:^(BOOL success, NSError * _Nullable error) {
//        if (success) {
//            // You successfully created the transaction!
//            NSLog(t.customerCode, t.bucketTransactionId);
//        } else if (error != NULL) {
//            NSLog(@"%@", error.localizedDescription);
//        }
//    }];
    
    // This is how we fetch the bil denominations:
//    [[Bucket shared] fetchBillDenominations:@"SGD" completion:^(BOOL success, NSError * _Nullable error) {
//        if (success) {
//            NSLog(@"Success!!!");
//        } else if (error != NULL) {
//
//        }
//    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
