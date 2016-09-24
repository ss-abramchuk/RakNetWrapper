//
//  RNPeerInterfaceTests.swift
//  MCPEServer
//
//  Created by Sergey Abramchuk on 13.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

import XCTest
import Darwin
import RakNetWrapper

class RNPeerInterfaceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // TODO: Test ban/unban methods
    
    // Test operability of startup and shutdown with multiple sockets
    func testPeerInterfaceStartupAndShutdownMultipleSockets() {
        guard let peer = RNPeerInterface() else {
            XCTFail("Peer Interface == nil")
            return
        }
        
        do {
            let socketDescriptors = [
                RNSocketDescriptor(port: 19132, address: nil),
                RNSocketDescriptor(port: 19133, address: nil)
            ]
            
            try peer.startup(maxConnections: 2, socketDescriptors: socketDescriptors)
  
            let maxPeers = peer.maximumNumberOfPeers
            XCTAssert(maxPeers == 2, "Incorrect amount of maximum peers: \(maxPeers)")
            
            let sturtupStatus = peer.isActive
            XCTAssert(sturtupStatus, "Network thread is not running")
            
            peer.shutdown(duration: 0)
            
            let shutdownStatus = peer.isActive
            XCTAssert(!shutdownStatus, "Network thread is running")
        } catch let error as NSError {
            XCTFail("Peer startup or shutdown failed with error: \(error.localizedDescription)")
        }
    }
    
    func testSettingAndGettingMaximumIncomingConnections() {
        guard let peer = RNPeerInterface() else {
            XCTFail("Peer Interface == nil")
            return
        }
        
        let maxConnections: UInt16 = 123
        
        peer.maximumIncomingConnections = maxConnections
        
        let returnedValue = peer.maximumIncomingConnections
        
        XCTAssert(returnedValue == maxConnections, "returnedValue = \(returnedValue) while maxConnections = \(maxConnections)")
    }
    
    func testConvertingGUIDToAddress() {
        guard let peer = RNPeerInterface() else {
            XCTFail("Peer Interface == nil")
            return
        }
        
        do {
            try peer.startup(maxConnections: 1, socketDescriptors: [RNSocketDescriptor()])
        } catch let error as NSError {
            XCTFail("Peer startup failed with error: \(error.localizedDescription)")
        }
        
        let myGUID = peer.myGUID
        XCTAssertTrue(myGUID > 0, "Returned incorrect GUID")
        
        let address = RNSystemAddress()!
        
        let returnedGUID = peer.getGUID(from: address)
        XCTAssertTrue(myGUID == returnedGUID, "Returned incorrect GUID")
    }
    
//    // Test connection of one RNPeerInterface to another
//    func testPeerInterfaceConnection() {
//        guard let server = RNPeerInterface(), client = RNPeerInterface() else {
//            XCTFail("One of Peer Interfaces == nil")
//            return
//        }
//        
//        // Initializing server
//        do {
//            let socketDescriptor = RNSocketDescriptor(port: 19132, andAddress: nil)
//            try server.startupWithMaxConnectionsAllowed(1, socketDescriptor: socketDescriptor)
//            server.setMaximumIncomingConnections(1)
//        } catch let error as NSError {
//            XCTFail("Server startup failed with error: \(error.localizedDescription)")
//        }
//        
//        // Initializing client and connect to server
//        let system = RNSystemAddress(address: "127.0.0.1", andPort: 19132)
//        do {
//            let socketDescriptor = RNSocketDescriptor()
//            try client.startupWithMaxConnectionsAllowed(1, socketDescriptor: socketDescriptor)
//            try client.connectToHost(system.address, remotePort: system.port)
//        } catch let error as NSError {
//            XCTFail("Connection to server failed with error: \(error.localizedDescription)")
//        }
//        
//        // Wait a little for connection
//        usleep(500000)
//        
//        // Get GUID of server to check connection state
//        let serverGUID = server.getMyGUID()
//        
//        // Get connection state
//        let stateWithGUID: RNConnectionState = client.getConnectionStateWithGUID(serverGUID)
//        let stateWithAddress: RNConnectionState = client.getConnectionStateWithAddress(system)
//        
//        XCTAssertTrue(stateWithGUID == .Connected, "State with GUID != Connected")
//        XCTAssertTrue(stateWithAddress == .Connected, "State with address and port != Connected")
//        
//        // Check server GUID
//        let returnedServerGUID = client.getGuidFromSystemAddress(system)
//        XCTAssertTrue(serverGUID == returnedServerGUID, "Returned server GUID is incorrect")
//        
//        // Get amount of connections
//        let numberOfConnections = server.numberOfConnections()
//        XCTAssert(numberOfConnections == 1)
//        
//        // Get list of connections
//        let connectionsList = client.getConnectionListWithNumberOfSystems(UInt16(numberOfConnections))
//        XCTAssert(connectionsList.count == Int(numberOfConnections))
//        
//        guard let connectedAddress = connectionsList[0] as? RNSystemAddress else {
//            XCTFail("Couldn't get address from list of connections")
//            return
//        }
//        
//        XCTAssert(connectedAddress.port == system.port && connectedAddress.address == system.address)
//        
//        // Close connection
//        client.closeConnectionWithGUID(serverGUID, sendNotification: true)
//        
//        // Wait a little for disconnection
//        usleep(100000)
//        
//        // Get connection state
//        let disconnectedState: RNConnectionState = client.getConnectionStateWithGUID(serverGUID)
//        
//        XCTAssertTrue(disconnectedState == .NotConnected, "State with GUID != NotConnected (\(disconnectedState))")
//    }
//    
//    // Test throwing error during connection to unknown domain.
//    func testPeerInterfaceFailConnection() {
//        guard let peer = RNPeerInterface() else {
//            XCTFail("Peer Interface == nil")
//            return
//        }
//        
//        do {
//            let socketDescriptor = RNSocketDescriptor()
//            try peer.startupWithMaxConnectionsAllowed(1, socketDescriptor: socketDescriptor)
//            try peer.connectToHost("www.this-site-doesn't-exist.com", remotePort: 19132)
//            
//            XCTFail("Connection attempt was successful, but should fail.")
//        } catch let error as NSError {
//            XCTAssert(error.code == 2, "Incorrect error code: \(error.code); Description: \(error.localizedDescription)")
//        }
//    }
//    
//    func testGettingConnectionsListWithIncorrectNumber() {
//        guard let peer = RNPeerInterface() else {
//            XCTFail("Peer Interface == nil")
//            return
//        }
//        
//        do {
//            let socketDescriptor = RNSocketDescriptor()
//            try peer.startupWithMaxConnectionsAllowed(1, socketDescriptor: socketDescriptor)
//        } catch let error as NSError {
//            XCTFail("Peer startup failed with error: \(error.localizedDescription)")
//        }
//        
//        let connectionsList = peer.getConnectionListWithNumberOfSystems(5)
//        XCTAssert(connectionsList.count == 0)
//    }
//    
//    // Test getting amount of all addresses this system has internally and getting local ip address
//    func testGetLocalIP() {
//        guard let peer = RNPeerInterface() else {
//            XCTFail("Peer Interface == nil")
//            return
//        }
//        
//        do {
//            let socketDescriptor = RNSocketDescriptor()
//            try peer.startupWithMaxConnectionsAllowed(1, socketDescriptor: socketDescriptor)
//        } catch let error as NSError {
//            XCTFail("Peer startup failed with error: \(error.localizedDescription)")
//        }
//        
//        let amountOffAddresses = peer.getNumberOfAddresses()
//        XCTAssert(amountOffAddresses > 0)
//        
//        let localIP = peer.getLocalIPWithIndex(0)
//        XCTAssertNotNil(localIP)
//    }
//    
//    // Test setting and getting offline ping response
//    func testSetOfflinePingData() {
//        guard let peer = RNPeerInterface() else {
//            XCTFail("Peer Interface == nil")
//            return
//        }
//        
//        do {
//            let socketDescriptor = RNSocketDescriptor()
//            try peer.startupWithMaxConnectionsAllowed(1, socketDescriptor: socketDescriptor)
//        } catch let error as NSError {
//            XCTFail("Peer startup failed with error: \(error.localizedDescription)")
//        }
//        
//        let value = "Hello!"
//        
//        let data = value.data(using: String.Encoding.utf8)
//        peer.setOfflinePingResponse(data)
//        
//        guard let returnedData = peer.getOfflinePingResponse() else {
//            XCTFail("Returned zero data")
//            return
//        }
//        
//        let returnedValue = String(data: returnedData, encoding: String.Encoding.utf8)
//        
//        XCTAssert(value == returnedValue, "Values are not the same")
//    }
//    
//    func testConnectedPing() {
//        // TODO: Implement testing connected ping
//        XCTFail("Testing connected ping is not implemented")
//    }
//    
//    func testUnconnectedPing() {
//        guard let server = RNPeerInterface(), client = RNPeerInterface() else {
//            XCTFail("One of Peer Interfaces == nil")
//            return
//        }
//        
//        // Initializing server
//        do {
//            let socketDescriptor = RNSocketDescriptor(port: 19132, andAddress: nil)
//            try server.startupWithMaxConnectionsAllowed(1, socketDescriptor: socketDescriptor)
//            server.setMaximumIncomingConnections(1)
//        } catch let error as NSError {
//            XCTFail("Server startup failed with error: \(error.localizedDescription)")
//        }
//        
//        let pongValue = "Hello!"
//        
//        let data = pongValue.data(using: String.Encoding.utf8)
//        server.setOfflinePingResponse(data)
//        
//        // Initializing client
//        do {
//            let socketDescriptor = RNSocketDescriptor()
//            try client.startupWithMaxConnectionsAllowed(1, socketDescriptor: socketDescriptor)
//        } catch let error as NSError {
//            XCTFail("Client sturtup failed with error: \(error.localizedDescription)")
//        }
//        
//        let system = RNSystemAddress(address: "127.0.0.1", andPort: 19132)
//        
//        let pingResult = client.pingAddress(system.address, remotePort: system.port, onlyReplyOnAcceptingConnections: false)
//        XCTAssert(pingResult, "Unable to ping host \(system.address):\(system.port)")
//        
//        // Wait a little for receiving pong
//        usleep(50000)
//        
//        guard let pong = client.receive() else {
//            XCTFail("Pong wasn't received")
//            return
//        }
//        
//        guard let identifier = RNMessageIdentifier(rawValue: pong.identifier) else {
//            XCTFail("Failed to get pong identifier")
//            return
//        }
//        
//        XCTAssert(identifier == .UnconnectedPong, "Incorrect pong identifier: \(identifier)")
//        
//        let offset = Int(pong.offset) + sizeof(UInt8) + sizeof(UInt32)
//        let returnedData = pong.data.subdataWithRange(NSMakeRange(offset, pong.data.length - offset))
//        let returnedValue = String(data: returnedData, encoding: String.Encoding.utf8)
//        
//        XCTAssert(returnedValue == pongValue)
//    }
//    
//    func testSendingAndReceiving() {
//        // TODO: Implement testing send and receiving packets
//        XCTFail("Testing send and receiving packets is not implemented")
//    }
//    
//    func testReceivingNilPacket() {
//        guard let peer = RNPeerInterface() else {
//            XCTFail("Peer Interface == nil")
//            return
//        }
//        
//        do {
//            let socketDescriptor = RNSocketDescriptor()
//            try peer.startupWithMaxConnectionsAllowed(1, socketDescriptor: socketDescriptor)
//        } catch let error as NSError {
//            XCTFail("Peer startup failed with error: \(error.localizedDescription)")
//        }
//        
//        let packet = peer.receive()
//        
//        XCTAssertNil(packet, "Received packet is not equal nil")
//    }
    
}
