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

-(double) roundingDecimalPlaces:(double)value precision:(int)precision {
    return [NSString stringWithFormat:@"%.*f", precision, value].doubleValue;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRegisterTerminal {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];
    
    [[Bucket shared] registerTerminalWithRetailerCode:@"bckt-1" country:@"us" completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            XCTAssertNil(error);
        } else {
            XCTAssertNotNil(error);
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:[NSArray arrayWithObjects:expectation,nil] timeout:5];
}

- (void)testGetBillDenominations {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];
    
    [[Bucket shared] getBillDenominationsWithCompletion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            XCTAssertNil(error);
        } else {
            XCTAssertNotNil(error);
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:[NSArray arrayWithObjects:expectation,nil] timeout:5];
}

- (void)testBucketAmount {
    // MARK: - Sane
    double bucketAmount = [[Bucket shared] bucketAmountWithChangeDueBack:0.55];
    XCTAssertEqual(bucketAmount, 0.55);
    
    bucketAmount = [[Bucket shared] bucketAmountWithChangeDueBack:12.34];
    XCTAssertEqual([self roundingDecimalPlaces:bucketAmount precision:2], 0.34);
    
    bucketAmount = [[Bucket shared] bucketAmountWithChangeDueBack:1.00];
    XCTAssertEqual([self roundingDecimalPlaces:bucketAmount precision:2], 0.00);
    
    bucketAmount = [[Bucket shared] bucketAmountWithChangeDueBack:5.00];
    XCTAssertEqual([self roundingDecimalPlaces:bucketAmount precision:2], 0.00);
    
    bucketAmount = [[Bucket shared] bucketAmountWithChangeDueBack:0.99];
    XCTAssertEqual([self roundingDecimalPlaces:bucketAmount precision:2], 0.99);
    
    bucketAmount = [[Bucket shared] bucketAmountWithChangeDueBack:9.99];
    XCTAssertEqual([self roundingDecimalPlaces:bucketAmount precision:2], 0.99);
    
    bucketAmount = [[Bucket shared] bucketAmountWithChangeDueBack:0.9];
    XCTAssertEqual([self roundingDecimalPlaces:bucketAmount precision:2], 0.90);
    
    // MARK: - Dr. Strange
    bucketAmount = [[Bucket shared] bucketAmountWithChangeDueBack:1.234];
    XCTAssertEqual([self roundingDecimalPlaces:bucketAmount precision:2], 0.23);
    
    bucketAmount = [[Bucket shared] bucketAmountWithChangeDueBack:2.345];
    XCTAssertEqual([self roundingDecimalPlaces:bucketAmount precision:2], 0.35);
    
    bucketAmount = [[Bucket shared] bucketAmountWithChangeDueBack:3.456];
    XCTAssertEqual([self roundingDecimalPlaces:bucketAmount precision:2], 0.46);
    
    // MARK: - Murphy's Law
    // bucketAmount = [[Bucket shared] bucketAmountWithChangeDueBack:9.999];
    // XCTAssertEqual([self roundingDecimalPlaces:bucketAmount], 0.00, "$0.00 should be bucketed for a $9.999 change.");
}

- (void)testCreateTransaction {
    XCTestExpectation *expectation =[[XCTestExpectation alloc] initWithDescription:@"Create a transaction."];
    
    // Make sure the retailer id, retailer secret, and terminal id are set.
    // Credentials.retailerId = @"6644211a-c02a-4413-b307-04a11b16e6a4";
    // Credentials.retailerSecret = @"9IlwMxfQLaOvC4R64GdX/xabpvAA4QBpqb1t8lJ7PTGeR4daLI/bxw==";
    // Credentials.terminalId = @"qwerty1234";
    
    long amount = 7834;
    
    //    Transaction *transaction = [[Transaction alloc] initWithAmount:amount clientTransactionId:@"test"];
    //    [transaction create :^(CreateTransactionResponse * _Nullable response, BOOL success, NSError * _Nullable error) {
    //        if (success == YES) {
    //            XCTAssertNotNil(response);
    //
    //            if (response != NULL) {
    //                XCTAssertEqual(response.amount, amount);
    //                XCTAssertTrue([response.clientTransactionId isEqualToString:@"test"]);
    //                XCTAssertNotEqual(response.customerCode, @"");
    //                XCTAssertNotNil(response.qrCodeContent);
    //            }
    //
    //            XCTAssertTrue(success == YES);
    //            XCTAssertNil(error);
    //        } else {
    //            XCTAssertNil(response);
    //            XCTAssertFalse(success == YES);
    //            XCTAssertNotNil(error);
    //        }
    //
    //        [expectation fulfill];
    //    }];
    
    [self waitForExpectations:[NSArray arrayWithObjects:expectation,nil] timeout:5];
}

@end
