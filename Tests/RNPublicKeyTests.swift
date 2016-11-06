//
//  RNPublicKeyTests.swift
//  RakNetWrapper
//
//  Created by Sergey Abramchuk on 06.11.16.
//
//

import XCTest
import RakNetWrapper

class RNPublicKeyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetSetServerKey() {
        let publicKey = RNPublicKey()
        
        guard let data = "SomeData".data(using: .utf8) else {
            XCTFail("Failed to generate data")
            return
        }
        
        publicKey.serverPublicKey = data
        
        guard let returnedData = publicKey.serverPublicKey else {
            XCTFail("Failed to retrieve server pyblic key")
            return
        }
        
        XCTAssert(data == returnedData)
    }
    
}
