//
//  RNSocketDescriptorTests.swift
//  MCPEServer
//
//  Created by Sergey Abramchuk on 22.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

import XCTest
import iOSRakNetWrapper

class RNSocketDescriptorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSocketDescriptorInitializeWithoutParams() {
        let descriptor = RNSocketDescriptor()
        
        let port = descriptor.port
        let address = descriptor.address
        let socketFamily = descriptor.socketFamily
        let blockingSocket = descriptor.blockingSocket
        
        XCTAssertTrue(port == 0)
        XCTAssertTrue(address == "")
        XCTAssertTrue(socketFamily == .IPV4)
        XCTAssertTrue(blockingSocket == true)
    }
    
    func testSocketDescriptorInitializeWithParams() {
        let defaultPort: UInt16 = 19132
        let defaultAddress = "127.0.0.1"
        
        let descriptor = RNSocketDescriptor(port: defaultPort, address: defaultAddress)
        descriptor.socketFamily = .IPV6
        descriptor.blockingSocket = false
        
        let port = descriptor.port
        let address = descriptor.address
        let socketFamily = descriptor.socketFamily
        let blockingSocket = descriptor.blockingSocket
        
        XCTAssertTrue(port == defaultPort)
        XCTAssertTrue(address == defaultAddress)
        XCTAssertTrue(socketFamily == .IPV6)
        XCTAssertTrue(blockingSocket == false)
    }
    
    func testSocketDescriptorInitializeWithNilAddress() {
        let defaultPort: UInt16 = 19132
        
        let descriptor = RNSocketDescriptor(port: defaultPort, address: nil)
        
        let port = descriptor.port
        let address = descriptor.address
        
        XCTAssertTrue(port == defaultPort)
        XCTAssertTrue(address == "")
    }
    
}
