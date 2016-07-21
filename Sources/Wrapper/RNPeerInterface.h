//
//  RNPeerInterface.h
//  MCPEServer
//
//  Created by Sergey Abramchuk on 13.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import "RNConnectionState.h"
#import "RNPacketPriority.h"
#import "RNPacketReliability.h"

#import <Foundation/Foundation.h>

@class RNSocketDescriptor;
@class RNSystemAddress;
@class RNPacket;

@interface RNPeerInterface : NSObject

#pragma mark Properties

/// Returns if the network thread is running.
@property (readonly, nonatomic) BOOL active;

/// Return the total number of connections we are allowed.
@property (readonly, nonatomic) unsigned int maximumNumberOfPeers;

/// Maximum number of incoming connections allowed.
@property (nonatomic) unsigned short maximumIncomingConnections;

/// Returns how many open connections there are at this time.
@property (readonly, nonatomic) unsigned short numberOfConnections;

/// Return own GUID
@property (readonly, nonatomic) unsigned long long myGUID;

#pragma mark Initializers

- (nullable instancetype)init;

#pragma mark Handling of Connections

/**
 *  Starts the network threads, opens the listen ports
 *
 *  @warning Set maximumIncomingConnections if you want to accept incoming connections.
 *
 *  @param maxConnections The maximum number of connections between this instance of RakPeer and another instance of RakPeer. Required so the network can preallocate and for thread safety. A pure client would set this to 1. A pure server would set it to the number of allowed clients. A hybrid would set it to the sum of both types of connections.
 *  @param descriptors    An array of RNSocketDescriptor structures to force RakNet to listen on a particular IP address or port (or both). Each RNSocketDescriptor will represent one unique socket.
 *  @param error          Pointer to NSError object, where error information is stored in case if function fails. You can pass nil if you don't want that information.
 *
 *  @return YES if sturtup succeeded, NO otherwise.
 */
- (BOOL)startupWithMaxConnectionsAllowed:(unsigned int)maxConnections socketDescriptors:(nonnull NSArray<RNSocketDescriptor *> *)descriptors error:(out NSError * __nullable * __nullable)error
    NS_SWIFT_NAME(startup(maxConnections:socketDescriptors:));

/// Stops the network threads and closes all connections.
/// @param blockDuration How long, in milliseconds, you should wait for all remaining messages to go out, including RNMessageIdentifierDisconnectionNotification. If 0, it doesn't wait at all.
- (void)shutdownWithDuration:(unsigned int)blockDuration
    NS_SWIFT_NAME(shutdown(duration:));

/// Connect to the specified host (ip or domain name) and server port.
/// @param host Either a dotted IP address or a domain name.
/// @param remotePort Which port to connect to on the remote machine.
/// @param error Pointer to NSError object, where error information is stored in case function fails. You can pass nil if you don't want that information.
/// @return YES on successful initiation, NO otherwise.
- (BOOL)connectToHost:(nonnull NSString *)host remotePort:(unsigned short)remotePort error:(out NSError * __nullable * __nullable)error;

/// Close the connection to another host (if we initiated the connection it will disconnect, if they did it will kick them out).
/// @param guid The GUID of the system we are checking to see if we are connected to
/// @param sendDisconnectionNotification YES to send .DisconnectionNotification to the recipient. NO to close it silently.
- (void)closeConnectionWithGUID:(unsigned long long)guid sendNotification:(BOOL)sendNotification;

/// Close the connection to another host (if we initiated the connection it will disconnect, if they did it will kick them out).
/// @param address Which system to close the connection to
/// @param sendDisconnectionNotification True to send .DisconnectionNotification to the recipient. False to close it silently.
- (void)closeConnectionWithAddress:(nonnull RNSystemAddress *)address sendNotification:(BOOL)sendNotification;

// TODO: Add full description for getConnectionStateWithGUID:
/// Returns if a system is connected, disconnected, connecting in progress, or various other states.
- (RNConnectionState)getConnectionStateWithGUID:(unsigned long long)guid;

// TODO: Add full description for getConnectionStateWithAddress:port
/// Returns if a system is connected, disconnected, connecting in progress, or various other states.
- (RNConnectionState)getConnectionStateWithAddress:(nonnull RNSystemAddress *)address;

/// Returns an array with the RNSystemAddress of all the systems we are connected to
- (nonnull NSArray *)getConnectionListWithNumberOfSystems:(unsigned short)numberOfSystems;

// TODO: Add full description for getSystemAddressFromGUID:
/// Given the GUID of a connected system, give us the system address of that system.
/// @param guid The GUID of the system we are converting to address.
/// @return
- (nonnull RNSystemAddress *)getSystemAddressFromGUID:(unsigned long long)guid;

// TODO: Add full description for getGuidFromSystemAddress:port:
/// Given a connected system, give us the unique GUID representing that instance of RakPeer.
- (unsigned long long)getGuidFromSystemAddress:(nonnull RNSystemAddress *)address;

/// Returns the number of IP addresses this system has internally. Get the actual addresses from getLocalIP:
- (unsigned int)getNumberOfAddresses;

/// Returns an IP address at index 0 to GetNumberOfAddresses - 1.
/// @param index Index into the list of IP addresses.
/// @return The local IP address at this index.
- (nullable NSString *)getLocalIPWithIndex:(unsigned int)index;

/// Returns how many open connections there are at this time.
- (unsigned short)numberOfConnections;

/// Sets the data to send along with a LAN server discovery or offline ping reply.
/// @warning Length of data should be under 400 bytes, as a security measure against flood attacks
/// @param data A block of data to store, or nil for none
- (void)setOfflinePingResponse:(nullable NSData *)data;

/// Returns a copy of the data passed to SetOfflinePingResponse.
- (nullable NSData *)getOfflinePingResponse;

// TODO: Add full description for pingAddress:remotePort:onlyReplyOnAcceptingConnections:
/// Send a ping to the specified unconnected system.
- (BOOL)pingAddress:(nonnull NSString *)address remotePort:(unsigned short)remotePort onlyReplyOnAcceptingConnections:(BOOL)onlyReplyOnAcceptingConnections;

// TODO: Add full description for pingAddress:
/// Send a ping to the specified connected system.
- (void)pingAddress:(nonnull RNSystemAddress *)address;

// TODO: Add full description for getLastPingForGUID:
- (int)getLastPingForGUID:(unsigned long long)guid;

// TODO: Add full description for getLastPingForAddress:
- (int)getLastPingForAddress:(nonnull RNSystemAddress *)address;;

// TODO: Add full description for sendData:priority:reliability:address:
- (unsigned int)sendData:(nonnull NSData *)data priority:(RNPacketPriority)priority reliability:(RNPacketReliability)reliability address:(nonnull RNSystemAddress *)address broadcast:(BOOL)broadcast;

// TODO: Add full description for sendData:priority:reliability:guid:
- (unsigned int)sendData:(nonnull NSData *)data priority:(RNPacketPriority)priority reliability:(RNPacketReliability)reliability guid:(unsigned long long)guid broadcast:(BOOL)broadcast;

/// Gets a message from the incoming message queue.
/// @return nil if no packets are waiting to be handled, otherwise a pointer to a packet.
- (nullable RNPacket *)receive;

@end
