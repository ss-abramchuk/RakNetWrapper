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

/**
 A data block that incoming connections must match. This can be just a password, or can be a stream of data.
 */
@property (nullable, nonatomic) NSData *password;

/**
 Returns YES if the network thread is running, otherwise NO.
 */
@property (readonly, nonatomic) BOOL isActive;

/**
 Return the total number of connections we are allowed.
 */
@property (readonly, nonatomic) unsigned int maximumNumberOfPeers;

/**
 Maximum number of incoming connections allowed.
 */
@property (nonatomic) unsigned short maximumIncomingConnections;

/**
 Returns how many open connections there are at this time.
 */
@property (readonly, nonatomic) unsigned short numberOfConnections;

/**
 Return own GUID.
 */
@property (readonly, nonatomic) unsigned long long myGUID;

/**
 Returns an array of IP addresses this system has internally.
 */
@property (nonnull, readonly, nonatomic) NSArray<NSString *> * localAddresses;

/**
 The array with the RNSystemAddress of all the systems we are connected to.
 */
@property (nonnull, readonly, nonatomic) NSArray<RNSystemAddress *> * connectionList;

/**
 The data to send along with a LAN server discovery or offline ping reply.
 
 @warning Length of data should be under 400 bytes, as a security measure against flood attacks.
 */
@property NSData * _Nullable offlinePingResponse;


#pragma mark Initializers

- (nullable instancetype)init;


#pragma mark Startup and Shutdown

/**
 Starts the network threads, opens the listen ports.
 
 @warning Set maximumIncomingConnections if you want to accept incoming connections.

 @param maxConnections The maximum number of connections between this instance of RakPeer and another instance of RakPeer. Required so the network can preallocate and for thread safety. A pure client would set this to 1. A pure server would set it to the number of allowed clients. A hybrid would set it to the sum of both types of connections.
 @param descriptors    An array of RNSocketDescriptor structures to force RakNet to listen on a particular IP address or port (or both). Each RNSocketDescriptor will represent one unique socket.
 @param error          A pointer to NSError object, where error information is stored in case if function fails. You can pass nil if you don't want that information.
 
 @return YES if sturtup succeeded, NO otherwise.
 */
- (BOOL)startupWithMaxConnectionsAllowed:(unsigned int)maxConnections
                       socketDescriptors:(nonnull NSArray *)descriptors
                                   error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(startup(maxConnections:socketDescriptors:));

/**
 Stops the network threads and closes all connections.
 
 @param blockDuration How long, in milliseconds, you should wait for all remaining messages to go out, including RNMessageIdentifierDisconnectionNotification. If 0, it doesn't wait at all.
 */
- (void)shutdownWithDuration:(unsigned int)blockDuration
NS_SWIFT_NAME(shutdown(duration:));


#pragma mark Security

/**
 If you accept connections, you must call this or else security will not be enabled for incoming connections. This feature requires more round trips, bandwidth, and CPU time for the connection handshake x64 builds require under 25% of the CPU time of other builds.

 @pre Must be called while offline.
 @pre LIBCAT_SECURITY must be defined to 1 in NativeFeatureIncludes.h for this function to have any effect.

 @param publicKey        A pointer to the public key for accepting new connections.
 @param privateKey       A pointer to the private key for accepting new connections.
 @param requireClientKey Should be set to false for most servers. Allows the server to accept a public key from connecting clients as a proof of identity but eats twice as much CPU time as a normal connection.

 @return YES if security was initialized, NO otherwise.
 */
- (BOOL)initializeSecurityWithPublicKey:(nonnull NSString *)publicKey
                             privateKey:(nonnull NSString *)privateKey
                       requireClientKey:(BOOL)requireClientKey
NS_SWIFT_NAME(initializeSecurity(publicKey:privateKey:requireClientKey:));

/**
 Disables security for incoming connections.

 @note Must be called while offline.
 */
- (void)disableSecurity;

/**
 If secure connections are on, do not use secure connections for a specific IP address. This is useful if you have a fixed-address internal server behind a LAN.

 @note Secure connections are determined by the recipient of an incoming connection. This has no effect if called on the system attempting to connect.

 @param ipAddress IP address to add. * wildcards are supported.
 */
- (void)addToSecurityExceptionList:(nonnull NSString *)ipAddress
NS_SWIFT_NAME(securityExceptionList(addAddress:));

/**
 Remove a specific connection previously added via addToSecurityExceptionList:

 @param ipAddress IP address to remove. Pass 0 to remove all IP addresses. * wildcards are supported.
 */
- (void)removeFromSecurityExceptionList:(nonnull NSString *)ipAddress
NS_SWIFT_NAME(securityExceptionList(removeAddress:));

/**
 Checks to see if a given IP is in the security exception list.

 @param ipAddress IP address to check.

 @return YES if address in the list, NO otherwise.
 */
- (BOOL)isInSecurityExceptionList:(nonnull NSString *)ipAddress
NS_SWIFT_NAME(securityExceptionList(hasAddress:));


#pragma mark Connection

/**
 Connect to the specified host (ip or domain name) and server port.

 @param host       Either a dotted IP address or a domain name.
 @param remotePort Which port to connect to on the remote machine.
 @param error      Pointer to NSError object, where error information is stored in case function fails. You can pass nil if you don't want that information.

 @return YES on successful initiation, NO otherwise.
 */
- (BOOL)connectToHost:(nonnull NSString *)host
           remotePort:(unsigned short)remotePort
                error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(connect(remoteHost:remotePort:));

/**
 Close the connection to another host (if we initiated the connection it will disconnect, if they did it will kick them out).

 @param guid             The GUID of the system we are checking to see if we are connected to.
 @param sendNotification YES to send .DisconnectionNotification to the recipient. NO to close it silently.
 */
- (void)disconnectRemoteGUID:(unsigned long long)guid
               sendNotification:(BOOL)sendNotification
NS_SWIFT_NAME(disconnect(remoteGUID:notify:));

/**
 Close the connection to another host (if we initiated the connection it will disconnect, if they did it will kick them out).

 @param address          Address of the system to close the connection to.
 @param sendNotification YES to send .DisconnectionNotification to the recipient. NO to close it silently.
 */
- (void)disconnectRemoteAddress:(nonnull RNSystemAddress *)address
                  sendNotification:(BOOL)sendNotification
NS_SWIFT_NAME(disconnect(remoteAddress:notify:));

/**
 Returns if a system is connected, disconnected, connecting in progress, or various other states.
 
 @note This locks a mutex, do not call too frequently during connection attempts or the attempt will take longer and possibly even timeout.
 
 @param guid The GUID of the system we are referring to.

 @return What state the remote system is in.
 */
- (RNConnectionState)getConnectionStateWithGUID:(unsigned long long)guid
NS_SWIFT_NAME(connectionState(remoteGUID:));

/**
 Returns if a system is connected, disconnected, connecting in progress, or various other states.
 
 @note This locks a mutex, do not call too frequently during connection attempts or the attempt will take longer and possibly even timeout.
 
 @param address Address of the system we are referring to.

 @return What state the remote system is in.
 */
- (RNConnectionState)getConnectionStateWithAddress:(nonnull RNSystemAddress *)address
NS_SWIFT_NAME(connectionState(remoteAddress:));


#pragma mark Ban

/**
 Bans an IP from connecting. Banned IPs persist between connections but are not saved on shutdown nor loaded on startup.
 
 @param ipAddress Dotted IP address. Can use * as a wildcard, such as 128.0.0.* will ban all IP addresses starting with 128.0.0.
 @param duration How many seconds for a temporary ban. Use 0 for a permanent ban.
 */
- (void)ban:(nonnull NSString *)ipAddress
            duration:(NSTimeInterval)duration
NS_SWIFT_NAME(ban(address:duration:));

/**
 Allows a previously banned IP to connect.
 
 @param ipAddress Dotted IP address. Can use * as a wildcard, such as 128.0.0.* will unban all IP addresses starting with 128.0.0.
 */
- (void)unban:(nonnull NSString *)ipAddress
NS_SWIFT_NAME(unban(address:));

/**
 Allows all previously banned IPs to connect.
 */
- (void)unbanAll;

/**
 Returns YES or NO indicating if a particular IP is banned.
 
 @param ipAddress Dotted IP address.
 
 @return YES if IP matches any IPs in the ban list, accounting for any wildcards. NO otherwise.
 */
- (BOOL)isBanned:(nonnull NSString *)ipAddress;


#pragma mark Ping

/**
 Send a ping to the specified unconnected system.

 @param address                         Either a dotted IP address or a domain name.  Can be 255.255.255.255 for LAN broadcast.
 @param remotePort                      Which port to connect to on the remote machine.
 @param onlyReplyOnAcceptingConnections Only request a reply if the remote system is accepting connections.

 @return YES on success, NO on failure (unknown hostname)
 */
- (BOOL)pingAddress:(nonnull NSString *)address
         remotePort:(unsigned short)remotePort
onlyReplyOnAcceptingConnections:(BOOL)onlyReplyOnAcceptingConnections
NS_SWIFT_NAME(ping(address:port:replyOnAcceptingConnections:));

/**
 Send a ping to the specified connected system.

 @param address Address of the connected system.
 */
- (void)pingAddress:(nonnull RNSystemAddress *)address
NS_SWIFT_NAME(ping(address:));

/**
 Returns the last ping time read for the specific system or -1 if none read yet.

 @param guid The GUID of the system we are referring to.

 @return The last ping time for this system, or -1.
 */
- (int)getLastPingForGUID:(unsigned long long)guid
NS_SWIFT_NAME(getLastPing(forGUID:));

/**
 Returns the last ping time read for the specific system or -1 if none read yet.

 @param address The address of the system we are referring to.

 @return The last ping time for this system, or -1.
 */
- (int)getLastPingForAddress:(nonnull RNSystemAddress *)address
NS_SWIFT_NAME(getLastPing(forAddress:));


#pragma mark Data

/**
 Sends a block of data to the specified system that you are connected to.
 
 @note This function only works while connected.
 @note The first byte should be a message identifier starting at RNMessageIdentifierUserPacketEnum.

 @param data        The block of data to send.
 @param priority    Desirable priority level for sending this data.
 @param reliability Desirable reliability for sending this data.
 @param address     Who to send this packet to, or in the case of broadcasting who not to send it to.
 @param broadcast   YES to send this packet to all connected systems. If YES, then address specifies who not to send the packet to.

 @return 0 on bad input. Otherwise a number that identifies this message. If \a reliability is a type that returns a receipt, on a later call to receive: you will get RNMessageIdentifierSndReceiptAcked or RNMessageIdentifierSndReceiptLoss with bytes 1-4 inclusive containing this number.
 */
- (unsigned int)sendData:(nonnull NSData *)data
                priority:(RNPacketPriority)priority
             reliability:(RNPacketReliability)reliability
                 address:(nonnull RNSystemAddress *)address
               broadcast:(BOOL)broadcast
NS_SWIFT_NAME(send(data:priority:reliability:address:broadcast:));

/**
 Sends a block of data to the specified system that you are connected to.
 
 @note This function only works while connected.
 @note The first byte should be a message identifier starting at RNMessageIdentifierUserPacketEnum.
 
 @param data        The block of data to send.
 @param priority    Desirable priority level for sending this data.
 @param reliability Desirable reliability for sending this data.
 @param guid        Who to send this packet to, or in the case of broadcasting who not to send it to.
 @param broadcast   YES to send this packet to all connected systems. If YES, then address specifies who not to send the packet to.
 
 @return 0 on bad input. Otherwise a number that identifies this message. If \a reliability is a type that returns a receipt, on a later call to receive: you will get RNMessageIdentifierSndReceiptAcked or RNMessageIdentifierSndReceiptLoss with bytes 1-4 inclusive containing this number.
 */
- (unsigned int)sendData:(nonnull NSData *)data
                priority:(RNPacketPriority)priority
             reliability:(RNPacketReliability)reliability
                    guid:(unsigned long long)guid
               broadcast:(BOOL)broadcast
NS_SWIFT_NAME(send(data:priority:reliability:guid:broadcast:));

/**
 Gets a message from the incoming message queue.

 @return nil if no packets are waiting to be handled, otherwise a recieved packet.
 */
- (nullable RNPacket *)receive;


#pragma mark Utils

/**
 Given the GUID of a connected system, give us the system address of that system.

 @param guid The GUID of the system we are converting to address.

 @return Address of the system
 */
- (nonnull RNSystemAddress *)getSystemAddressFromGUID:(unsigned long long)guid
NS_SWIFT_NAME(getAddress(fromGUID:));

/**
 Given a connected system, give us the unique GUID representing that instance of RakPeer.

 @param address The address of the system we are converting to GUID.

 @return The GUID of the system
 */
- (unsigned long long)getGuidFromSystemAddress:(nonnull RNSystemAddress *)address
NS_SWIFT_NAME(getGUID(fromAddress:));

@end
