//
//  RNPeerInterface.m
//  MCPEServer
//
//  Created by Sergey Abramchuk on 13.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import "RNPeerInterface.h"
#import "RNConstants.h"
#import "RNSocketFamily.h"
#import "RNSocketDescriptor.h"
#import "RNSocketDescriptor+Internal.h"
#import "RNSystemAddress.h"
#import "RNSystemAddress+Internal.h"
#import "RNPacket+Internal.h"
#import "RNPublicKey+Internal.h"

#import "MessageIdentifiers.h"
#import "RakPeerInterface.h"
#import "RakNetTypes.h"

#import <sys/socket.h>

using namespace RakNet;


@interface RNPeerInterface ()

@property (nonatomic, assign, readwrite) RakPeerInterface *peer;

@end


@implementation RNPeerInterface

#pragma mark Computed Properties Implementation

- (NSData *)password {
    int length = 1024;
    char data[1024] = {};
    
    self.peer->GetIncomingPassword((char *)&data, &length);
    
    if (length == 0) {
        return nil;
    } else {
        return [NSData dataWithBytes:&data length:length];
    }
}

- (void)setPassword:(NSData *)password {
    unsigned int length = password != nil ? [password length] : 0;
    const char *data = password != nil ? (const char *)[password bytes] : 0;
    
    self.peer->SetIncomingPassword(data, length);
}

- (BOOL)isActive {
    return self.peer->IsActive();
}

- (unsigned int)maximumNumberOfPeers {
    return self.peer->GetMaximumNumberOfPeers();
}

- (unsigned short)maximumIncomingConnections {
    return self.peer->GetMaximumIncomingConnections();
}

- (void)setMaximumIncomingConnections:(unsigned short)numberAllowed {
    self.peer->SetMaximumIncomingConnections(numberAllowed);
}

- (unsigned short)numberOfConnections {
    return self.peer->NumberOfConnections();
}

- (unsigned long long)myGUID {
    RakNetGUID guid = self.peer->GetMyGUID();
    return (unsigned long long)guid.g;
}

- (NSArray<NSString *> * _Nonnull)localAddresses {
    unsigned int addressCount = self.peer->GetNumberOfAddresses();
    
    NSMutableArray *addresses = [[NSMutableArray alloc] init];
    
    for (unsigned int i = 0; i < addressCount; i++) {
        const char *address = self.peer->GetLocalIP(i);
        
        if (strcmp(address, UNASSIGNED_SYSTEM_ADDRESS.ToString()) != 0) {
            [addresses addObject:[NSString stringWithUTF8String:address]];
        }
    }
    
    return [NSArray arrayWithArray:addresses];
}

- (NSArray<RNSystemAddress *> * _Nonnull)connectionList {
    unsigned short connectionsCount = self.peer->NumberOfConnections();
    
    SystemAddress *systems = new SystemAddress[connectionsCount];
    self.peer->GetConnectionList(systems, &connectionsCount);
    
    NSMutableArray *connections = [NSMutableArray arrayWithCapacity:connectionsCount];
    
    for (int i = 0; i < connectionsCount; i++) {
        SystemAddress address = systems[i];
        [connections addObject:[[RNSystemAddress alloc] initWithSystemAddress:address]];
    }
    
    delete [] systems;
    
    return [NSArray arrayWithArray:connections];
}

- (NSData * _Nullable)offlinePingResponse {
    char *data = NULL;
    unsigned int length = 0;
    
    self.peer->GetOfflinePingResponse(&data, &length);
    
    if (data == NULL) {
        return nil;
    } else {
        return [NSData dataWithBytes:data length:length];
    }
}

- (void)setOfflinePingResponse:(NSData * _Nullable)data {
    unsigned int length = data != nil ? [data length] : 0;
    const char *bytes = (const char *)[data bytes];
    
    self.peer->SetOfflinePingResponse(bytes, length);
}


#pragma mark Initializers

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.peer = RakPeerInterface::GetInstance();
    }
    
    return self;
}


#pragma mark Startup and Shutdown

- (BOOL)startupWithMaxConnectionsAllowed:(unsigned int)maxConnections
                       socketDescriptors:(nonnull NSArray<RNSocketDescriptor *> *)descriptors
                                   error:(out NSError * __nullable * __nullable)error
{
    SocketDescriptor *socketDescriptors = new SocketDescriptor[descriptors.count];
    
    for (int i = 0; i < descriptors.count; i++) {
        socketDescriptors[i] = *(descriptors[i].socketDescriptor);
    }
    
    StartupResult result = self.peer->Startup(maxConnections, socketDescriptors, descriptors.count);
    
    delete [] socketDescriptors;
    
    if (result == RAKNET_STARTED) {
        return YES;
    } else {
        NSDictionary *errorDictionary;
        
        switch (result) {
            case RAKNET_ALREADY_STARTED:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Raknet already started." };
                break;
                
            case INVALID_SOCKET_DESCRIPTORS:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Invalid socket descriptors." };
                break;
                
            case INVALID_MAX_CONNECTIONS:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Invalid max connections." };
                break;
                
            case SOCKET_FAMILY_NOT_SUPPORTED:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Socket family not supported." };
                break;
                
            case SOCKET_PORT_ALREADY_IN_USE:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Socket port already in use." };
                break;
                
            case SOCKET_FAILED_TO_BIND:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Socket failed to bind." };
                break;
                
            case SOCKET_FAILED_TEST_SEND:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Socket failed test send." };
                break;
                
            case PORT_CANNOT_BE_ZERO:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Port cannot be zero." };
                break;
                
            case FAILED_TO_CREATE_NETWORK_THREAD:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Failed to create network thread." };
                break;
                
            case COULD_NOT_GENERATE_GUID:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Could not generate guid." };
                break;
                
            default:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Startup other failure." };
                break;
        }
        
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain code:result userInfo:errorDictionary];
        return NO;
    }
}

- (void)shutdownWithDuration:(unsigned int)blockDuration {
    self.peer->Shutdown(blockDuration);
}


#pragma mark Security

- (BOOL)initializeSecurityWithPublicKey:(NSData *)publicKey
                             privateKey:(NSData *)privateKey
                       requireClientKey:(BOOL)requireClientKey
{
    return self.peer->InitializeSecurity((const char *)[publicKey bytes], (const char *)[privateKey bytes], requireClientKey);
}

- (void)disableSecurity {
    self.peer->DisableSecurity();
}

- (void)addToSecurityExceptionList:(NSString *)ipAddress {
    self.peer->AddToSecurityExceptionList([ipAddress UTF8String]);
}

- (void)removeFromSecurityExceptionList:(NSString *)ipAddress {
    self.peer->RemoveFromSecurityExceptionList([ipAddress UTF8String]);
}

- (BOOL)isInSecurityExceptionList:(NSString *)ipAddress {
    return self.peer->IsInSecurityExceptionList([ipAddress UTF8String]);
}


#pragma mark Connection

- (BOOL)connectToHost:(nonnull NSString *)host
           remotePort:(unsigned short)remotePort
             password:(nullable NSData *)password
            publicKey:(nullable RNPublicKey *)publicKey
                error:(out NSError * __nullable * __nullable)error
{
    
    const char *passwordData = password != nil ? (const char *)[password bytes] : 0;
    int passwordDataLength = password != nil ? [password length] : 0;
    
    RakNet::PublicKey *key = publicKey != nil && publicKey.publicKey != NULL ? publicKey.publicKey : NULL;
    
    int result = self.peer->Connect([host UTF8String], remotePort, passwordData, passwordDataLength, key);
    
    if (result == CONNECTION_ATTEMPT_STARTED) {
        return YES;
    } else {
        NSDictionary *errorDictionary;
        
        switch (result) {
            case INVALID_PARAMETER:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Invalid parameters." };
                break;
                
            case CANNOT_RESOLVE_DOMAIN_NAME:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Cannot resolve domain name." };
                break;
                
            case ALREADY_CONNECTED_TO_ENDPOINT:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Already connected to endpoint." };
                break;
                
            case CONNECTION_ATTEMPT_ALREADY_IN_PROGRESS:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Connection attempt already in progress." };
                break;
                
            case SECURITY_INITIALIZATION_FAILED:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Security initialization failed." };
                break;
                
            default:
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Unknown error." };
                break;
        }
        
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain code:result userInfo:errorDictionary];
        return NO;
    }
}

- (void)disconnectRemoteGUID:(unsigned long long)guid sendNotification:(BOOL)sendNotification {
    RakNetGUID rakNetGUID = [self getRakNetGUIDFromValue:guid];
    self.peer->CloseConnection(rakNetGUID, sendNotification);
}

- (void)disconnectRemoteAddress:(nonnull RNSystemAddress *)address sendNotification:(BOOL)sendNotification {
    self.peer->CloseConnection(*address.systemAddress, sendNotification);
}

- (RNConnectionState)getConnectionStateWithGUID:(unsigned long long)guid {
    RakNetGUID rakNetGUID = [self getRakNetGUIDFromValue:guid];
    
    int result = self.peer->GetConnectionState(rakNetGUID);
    
    return [self getConnectionStateFromValue:result];
}

- (RNConnectionState)getConnectionStateWithAddress:(nonnull RNSystemAddress *)address {
    int result = self.peer->GetConnectionState(*address.systemAddress);
    return [self getConnectionStateFromValue:result];
}


#pragma mark Ban

- (void)ban:(NSString *)ipAddress duration:(NSTimeInterval)duration {
    self.peer->AddToBanList([ipAddress UTF8String], duration);
}

- (void)unban:(NSString *)ipAddress {
    self.peer->RemoveFromBanList([ipAddress UTF8String]);
}

- (void)unbanAll {
    self.peer->ClearBanList();
}

- (BOOL)isBanned:(NSString *)ipAddress {
    return self.peer->IsBanned([ipAddress UTF8String]);
}


#pragma mark Ping

- (BOOL)pingAddress:(nonnull NSString *)address remotePort:(unsigned short)remotePort onlyReplyOnAcceptingConnections:(BOOL)onlyReplyOnAcceptingConnections {
    return self.peer->Ping([address UTF8String], remotePort, onlyReplyOnAcceptingConnections);
}

- (void)pingAddress:(RNSystemAddress *)address {
    self.peer->Ping(*(address.systemAddress));
}

- (int)getLastPingForGUID:(unsigned long long)guid {
    RakNetGUID rakNetGUID = [self getRakNetGUIDFromValue:guid];
    return self.peer->GetLastPing(rakNetGUID);
}

- (int)getLastPingForAddress:(RNSystemAddress *)address {
    return self.peer->GetLastPing(*(address.systemAddress));
}


#pragma mark Data

- (unsigned int)sendData:(nonnull NSData *)data priority:(RNPacketPriority)priority reliability:(RNPacketReliability)reliability address:(nonnull RNSystemAddress *)address broadcast:(BOOL)broadcast {
    unsigned int length =[data length];
    const char *bytes = (const char *)[data bytes];
    PacketPriority packetPriority = [self getPriorityFromValue:priority];
    PacketReliability packetReliability = [self getReliabilityFromValue:reliability];
    
    return self.peer->Send(bytes, length, packetPriority, packetReliability, 0, *address.systemAddress, broadcast);
}

- (unsigned int)sendData:(nonnull NSData *)data priority:(RNPacketPriority)priority reliability:(RNPacketReliability)reliability guid:(unsigned long long)guid broadcast:(BOOL)broadcast {
    unsigned int length = [data length];
    const char *bytes = (const char *)[data bytes];
    PacketPriority packetPriority = [self getPriorityFromValue:priority];
    PacketReliability packetReliability = [self getReliabilityFromValue:reliability];
    RakNetGUID rakNetGUID = [self getRakNetGUIDFromValue:guid];
    
    return self.peer->Send(bytes, length, packetPriority, packetReliability, 0, rakNetGUID, broadcast);
}

- (nullable RNPacket *)receive {
    Packet *rakNetPacket = self.peer->Receive();
    if (rakNetPacket == nil) {
        return nil;
    } else {
        RNPacket *packet = [[RNPacket alloc] initWithPacket:rakNetPacket];
        self.peer->DeallocatePacket(rakNetPacket);
        return packet;
    }
}


#pragma mark Utils

- (nonnull RNSystemAddress *)getSystemAddressFromGUID:(unsigned long long)guid; {
    RakNetGUID rakNetGUID = [self getRakNetGUIDFromValue:guid];
    SystemAddress systemAddress = self.peer->GetSystemAddressFromGuid(rakNetGUID);
    
    return [[RNSystemAddress alloc] initWithSystemAddress:systemAddress];
}

- (unsigned long long)getGuidFromSystemAddress:(nonnull RNSystemAddress *)address {
    RakNetGUID result = self.peer->GetGuidFromSystemAddress(*address.systemAddress);
    
    if (result == UNASSIGNED_RAKNET_GUID) {
        return 0;
    } else {
        return result.g;
    }
}


#pragma mark Private Utility Methods

- (RNConnectionState)getConnectionStateFromValue:(int)value {
    switch (value) {
        case IS_PENDING:
            return RNConnectionStatePending;
            break;
            
        case IS_CONNECTING:
            return RNConnectionStateConnecting;
            break;
            
        case IS_CONNECTED:
            return RNConnectionStateConnected;
            break;
            
        case IS_DISCONNECTING:
            return RNConnectionStateDisconnecting;
            break;
            
        case IS_SILENTLY_DISCONNECTING:
            return RNConnectionStateSilentlyDisconnecting;
            break;
            
        case IS_DISCONNECTED:
            return RNConnectionStateDisconnected;
            break;
            
        default:
            return RNConnectionStateNotConnected;
            break;
    }
}

- (RakNetGUID)getRakNetGUIDFromValue:(unsigned long long)value {
    RakNetGUID rakNetGUID;
    rakNetGUID.g = (uint64_t)value;
    rakNetGUID.systemIndex = (SystemIndex) - 1;
    
    return rakNetGUID;
}

- (PacketPriority)getPriorityFromValue:(RNPacketPriority)value {
    switch (value) {
        case RNPacketPriorityImmediatePriority:
            return IMMEDIATE_PRIORITY;
            
        case RNPacketPriorityHighPriority:
            return HIGH_PRIORITY;
            
        case RNPacketPriorityMediumPriority:
            return MEDIUM_PRIORITY;
            
        default:
            return LOW_PRIORITY;
    }
}

- (PacketReliability)getReliabilityFromValue:(RNPacketReliability)value {
    switch (value) {
        case RNPacketReliabilityReliable:
            return RELIABLE;
            
        case RNPacketReliabilityReliableOrdered:
            return RELIABLE_ORDERED;
            
        case RNPacketReliabilityReliableSequenced:
            return RELIABLE_SEQUENCED;
            
        case RNPacketReliabilityReliableWithAckReceipt:
            return RELIABLE_WITH_ACK_RECEIPT;
            
        case RNPacketReliabilityReliableOrderedWithAckReceipt:
            return RELIABLE_ORDERED_WITH_ACK_RECEIPT;
            
        case RNPacketReliabilityUnreliableSequenced:
            return UNRELIABLE_SEQUENCED;
            
        case RNPacketReliabilityUnreliableWithAckReceipt:
            return UNRELIABLE_WITH_ACK_RECEIPT;
            
        default:
            return UNRELIABLE;
    }
}

- (void)dealloc {
    RakPeerInterface::DestroyInstance(self.peer);
}

@end
