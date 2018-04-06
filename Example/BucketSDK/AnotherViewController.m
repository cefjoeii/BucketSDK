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
    [Bucket.shared setEnvironment: DeploymentEnvironmentDevelopment];
    // Do any additional setup after loading the view.
    [[Bucket shared] fetchBillDenominationsWithCompletion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            
        } else if (error != NULL) {
            
        }
    }];
    
    Transaction *t = [[Transaction alloc] initWithAmount:45 clientTransactionId:@"ZDFRPHGYKOUG"];
    [t create:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            // You successfully created the transaction!
            
        } else if (error != NULL) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
