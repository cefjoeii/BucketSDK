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

NSString *customerCode = @"";
int eventId = -1;

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

- (void)testCreateSimpleTransaction {
    XCTestExpectation *expectation =[[XCTestExpectation alloc] init];
    
    double bucketAmount = [[Bucket shared] bucketAmountWithChangeDueBack:1.55];
    CreateTransactionRequest *request = [[CreateTransactionRequest alloc] initWithAmount:bucketAmount];
    
    [[Bucket shared] createTransaction:request completion:^(BOOL success, CreateTransactionResponse * _Nullable response, NSError * _Nullable error) {
        if (success) {
            XCTAssertNil(error);
            
            // Assert response attributes
            XCTAssertNotNil(response);
            XCTAssertNotNil(response.customerCode);
            XCTAssertNotNil(response.qrCode);
            XCTAssertNotEqual(response.bucketTransactionId, -1);
            XCTAssertEqual(response.amount, [self roundingDecimalPlaces:bucketAmount precision:2]);
            XCTAssertNil(response.locationId);
            XCTAssertNil(response.clientTransactionId);
            
            customerCode = response.customerCode;
        } else {
            XCTAssertNotNil(error);
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:[NSArray arrayWithObjects:expectation,nil] timeout:5];
}

- (void) testCreateDetailedTransaction {
    XCTestExpectation *expectation =[[XCTestExpectation alloc] init];
    
    double bucketAmount = [[Bucket shared] bucketAmountWithChangeDueBack:1.55];
    CreateTransactionRequest *request = [[CreateTransactionRequest alloc] initWithAmount:bucketAmount];
    request.totalTransactionAmount = 6.30;
    request.locationId = @"locationId";
    request.clientTransactionId = @"clientTransactionId";
    request.employeeCode = @"1234";
    request.eventId = nil;
    
    [[Bucket shared] createTransaction:request completion:^(BOOL success, CreateTransactionResponse * _Nullable response, NSError * _Nullable error) {
        if (success) {
            XCTAssertNil(error);
            
            // Assert response attributes
            XCTAssertNotNil(response);
            XCTAssertNotNil(response.customerCode);
            XCTAssertNotNil(response.qrCode);
            XCTAssertNotEqual(response.bucketTransactionId, -1);
            XCTAssertEqual(response.amount, [self roundingDecimalPlaces:bucketAmount precision:2]);
            XCTAssertTrue([response.locationId isEqualToString:request.locationId]);
            XCTAssertTrue([response.clientTransactionId isEqualToString:request.clientTransactionId]);
            
            customerCode = response.customerCode;
        } else {
            XCTAssertNotNil(error);
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:[NSArray arrayWithObjects:expectation,nil] timeout:5];
}

- (void) testRefundTransaction {
    XCTestExpectation *expectation =[[XCTestExpectation alloc] init];
    
    [[Bucket shared] refundTransactionWithCustomerCode:customerCode completion:^(BOOL success, RefundTransactionResponse * _Nullable response, NSError * _Nullable error) {
        if (success) {
            XCTAssertNotNil(response);
            XCTAssertNil(error);
        } else {
            XCTAssertNil(response);
            XCTAssertNotNil(error);
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:[NSArray arrayWithObjects:expectation,nil] timeout:5];
}

- (void) testDeleteTransaction {
    XCTestExpectation *expectation =[[XCTestExpectation alloc] init];
    
    [[Bucket shared] deleteTransactionWithCustomerCode:customerCode completion:^(BOOL success, DeleteTransactionResponse * _Nullable response, NSError * _Nullable error) {
        if (success) {
            XCTAssertNotNil(response);
            XCTAssertNil(error);
        } else {
            XCTAssertNil(response);
            XCTAssertNotNil(error);
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:[NSArray arrayWithObjects:expectation,nil] timeout:5];
}

- (void) testInvalidGetReports {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];
    GetReportRequest *request = [[GetReportRequest alloc] initWithDay:@"This is an invalid day date String."];
    [[Bucket shared] getReports:request completion:^(BOOL success, GetReportsResponse * _Nullable response, NSError * _Nullable error) {
        XCTAssertFalse(success);
        XCTAssertNil(response);
        XCTAssertNotNil(error);
        XCTAssertTrue([error.localizedDescription isEqualToString:@"Please make sure that the date is valid."]);
        
        [expectation fulfill];
    }];
    [self waitForExpectations:[NSArray arrayWithObjects:expectation,nil] timeout:1];
    
    expectation = [[XCTestExpectation alloc] init];
    request = [[GetReportRequest alloc] initWithStartString:@"This is an invalid start date String." endString:@"This is an invalid end date String."];
    [[Bucket shared] getReports:request completion:^(BOOL success, GetReportsResponse * _Nullable response, NSError * _Nullable error) {
        XCTAssertFalse(success);
        XCTAssertNil(response);
        XCTAssertNotNil(error);
        XCTAssertTrue([error.localizedDescription isEqualToString:@"Please make sure that the date is valid."]);
        
        [expectation fulfill];
    }];
    [self waitForExpectations:[NSArray arrayWithObjects:expectation,nil] timeout:1];
}

- (void) testValidGetReports {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];
    GetReportRequest *request = [[GetReportRequest alloc] initWithStartString:@"2018-09-01 00:00:00+0800" endString:@"2018-11-20 00:00:00+0800"];
    [[Bucket shared] getReports:request completion:^(BOOL success, GetReportsResponse * _Nullable response, NSError * _Nullable error) {
        if (success) {
            XCTAssertNotNil(response);
            XCTAssertNil(error);
        } else {
            XCTAssertNil(response);
            XCTAssertNotNil(error);
        }
        
        [expectation fulfill];
    }];
    [self waitForExpectations:[NSArray arrayWithObjects:expectation,nil] timeout:5];
    
    expectation = [[XCTestExpectation alloc] init];
    request = [[GetReportRequest alloc] initWithStartInt:1535760000 endInt:1542672000];
    [[Bucket shared] getReports:request completion:^(BOOL success, GetReportsResponse * _Nullable response, NSError * _Nullable error) {
        if (success) {
            XCTAssertNotNil(response);
            XCTAssertNil(error);
        } else {
            XCTAssertNil(response);
            XCTAssertNotNil(error);
        }
        
        [expectation fulfill];
    }];
    [self waitForExpectations:[NSArray arrayWithObjects:expectation,nil] timeout:5];
}

- (void) testInvalidGetEvents {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];
    
    GetEventsRequest *request = [[GetEventsRequest alloc] initWithStartString:@"This is an invalid start date String."
                                                                    endString:@"This is an invalid end date String."];
    
    [[Bucket shared] getEvents:request completion:^(BOOL success, GetEventsResponse * _Nullable response, NSError * _Nullable error) {
        XCTAssertFalse(success);
        XCTAssertNil(response);
        XCTAssertNotNil(error);
        XCTAssertTrue([error.localizedDescription isEqualToString:@"Please make sure that the date is valid."]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:[NSArray arrayWithObjects:expectation,nil] timeout:1];
}

@end
