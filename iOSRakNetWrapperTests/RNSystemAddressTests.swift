//
//  RNSystemAddressTests.swift
//  MCPEServer
//
//  Created by Sergey Abramchuk on 24.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

import XCTest
@testable import iOSRakNetWrapper

class RNSystemAddressTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testRNSystemAddressInitialization() {
//        let unassignedSystemAddress = RNSystemAddress()
//        XCTAssert(unassignedSystemAddress.address == "UNASSIGNED_SYSTEM_ADDRESS")
//        
//        let localhost = "127.0.0.1"
//        let localPort: UInt16 = 19132
//        
//        let assignedSystemAddress = RNSystemAddress(address: localhost)
//        XCTAssert(assignedSystemAddress.address == localhost, "Local address \(localhost) is not equal to returned value: \(assignedSystemAddress.address)")
//        
//        let assignedSystemAddressWithPort = RNSystemAddress(address: localhost, andPort: localPort)
//        XCTAssert(assignedSystemAddressWithPort.address == localhost && assignedSystemAddressWithPort.port == localPort, "Local address \(localhost) or local port \(localPort) is not equal to returned values: \(assignedSystemAddressWithPort.address):\(assignedSystemAddressWithPort.port)")
//    }
//    
//    func testEqualityOfSystemAddresses() {
//        let localhost = "127.0.0.1"
//        let localPort: UInt16 = 19132
//        
//        let firstAddress = RNSystemAddress(address: localhost, andPort: localPort)
//        let secondAddress = RNSystemAddress(address: localhost, andPort: localPort)
//        
//        XCTAssert(firstAddress == secondAddress, "Values are not equal")
//    }
    
}
