//
//  ObjectiveCTests.m
//  BucketSDK_Tests
//
//  Created by Ceferino Jose II on 7/24/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import BucketSDK;

@interface ObjectiveCTests : XCTestCase

@end

@implementation ObjectiveCTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testRegisterDevice {
    XCTestExpectation *expectation =  [[XCTestExpectation alloc] initWithDescription:@"Register the device with that terminalId."];
    
    [[Bucket shared] registerDeviceWith:@"1234" :^(BOOL success, NSError * _Nullable error) {
        XCTAssertTrue(success == YES, @"For now, the register device function should just work.");
        XCTAssertNil(error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:[NSArray arrayWithObjects:expectation,nil] timeout:5];
}

- (void)testFetchBillDenominations {
    XCTestExpectation *expectationForUSD =  [[XCTestExpectation alloc] initWithDescription:@"Fetch the USD denominations."];
    
    [[Bucket shared] fetchBillDenominationsFor:BillDenominationUsd :^(BOOL success, NSError * _Nullable error) {
        XCTAssertTrue(success == YES, @"USD denominations should be fetched.");
        XCTAssertNil(error);
        
        [expectationForUSD fulfill];
    }];
    
    [self waitForExpectations:[NSArray arrayWithObjects:expectationForUSD,nil] timeout:1];
    
    XCTestExpectation *expectationForSGD =  [[XCTestExpectation alloc] initWithDescription:@"Fetch the SGD denominations."];
    
    [[Bucket shared] fetchBillDenominationsFor:BillDenominationSgd :^(BOOL success, NSError * _Nullable error) {
        XCTAssertTrue(success == YES, @"SGD denominations should be fetched.");
        XCTAssertNil(error);
        
        [expectationForSGD fulfill];
    }];
    
    [self waitForExpectations:[NSArray arrayWithObjects:expectationForSGD,nil] timeout:1];
}

- (void)testCloseInterval {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Close the interval with the interval id of '20170101'."];
    
    [[Bucket shared] closeWithIntervalId:@"20170101" :^(CloseIntervalResponse * _Nullable response, BOOL success, NSError * _Nullable error) {
        XCTAssertFalse(success == YES, @"intervalId = '20170101' has been previously closed.");
        XCTAssertNotNil(error);
        
        [expectation fulfill];
        
        [self waitForExpectations:[NSArray arrayWithObjects:expectation,nil] timeout:5];
    }];
}

- (void)testBucketAmount {
    long bucketAmount = [[Bucket shared] bucketAmountFor:1000];
    XCTAssertEqual(bucketAmount, 0, @"Bucket amount should be zero when the change due back is 1000.");
    
    bucketAmount = [[Bucket shared] bucketAmountFor:1234];
    XCTAssertEqual(bucketAmount, 34, @"Bucket amount should be 34 when the change due back is 1234.");
    
    bucketAmount = [[Bucket shared] bucketAmountForDecimal:1.0];
    XCTAssertEqual(bucketAmount, 100, @"Bucket amout should be 100, not 10, when the change due back is 1.0 or 1.00.");
}

- (void)testCreateTransaction {
    XCTestExpectation *expectation =[[XCTestExpectation alloc] initWithDescription:@"Create a transaction."];
    
    // Make sure the retailer id, retailer secret, and terminal id are set.
    Credentials.retailerId = @"6644211a-c02a-4413-b307-04a11b16e6a4";
    Credentials.retailerSecret = @"9IlwMxfQLaOvC4R64GdX/xabpvAA4QBpqb1t8lJ7PTGeR4daLI/bxw==";
    Credentials.terminalId = @"qwerty1234";
    
    long amount = 7834;
    
    Transaction *transaction = [[Transaction alloc] initWithAmount:amount clientTransactionId:@"test"];
    [transaction create :^(CreateTransactionResponse * _Nullable response, BOOL success, NSError * _Nullable error) {
        if (success == YES) {
            XCTAssertNotNil(response);
            
            if (response != NULL) {
                XCTAssertEqual(response.amount, amount);
                XCTAssertTrue([response.clientTransactionId isEqualToString:@"test"]);
                XCTAssertNotEqual(response.customerCode, @"");
                XCTAssertNotNil(response.qrCodeContent);
            }
            
            XCTAssertTrue(success == YES);
            XCTAssertNil(error);
        } else {
            XCTAssertNil(response);
            XCTAssertFalse(success == YES);
            XCTAssertNotNil(error);
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:[NSArray arrayWithObjects:expectation,nil] timeout:5];
}

@end
