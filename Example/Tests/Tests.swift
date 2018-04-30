import XCTest
import BucketSDK

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCreateTransaction() {
        
        // Make sure the client id & client secret is set:  these are 
        Bucket.Credentials.clientId = "6644211a-c02a-4413-b307-04a11b16e6a4"
        Bucket.Credentials.clientSecret = "9IlwMxfQLaOvC4R64GdX/xabpvAA4QBpqb1t8lJ7PTGeR4daLI/bxw=="
        
        let transaction = Bucket.Transaction(amount: 78, clientTransactionId: "ClientTransactionId")
        transaction.create { (success, error) in
            if success {
                print(success)
            } else if !error.isNil {
                print(error!.localizedDescription)
            }
        }
        
    }
    
}
