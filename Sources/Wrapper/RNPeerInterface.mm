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

- (unsigned int)maximumNumberOfPeers {
    return self.peer->GetMaximumNumberOfPeers();
}

- (unsigned short)maximumIncomingConnections {
    return self.peer->GetMaximumIncomingConnections();
}

- (void)setMaximumIncomingConnections:(unsigned short)numberAllowed {
    self.peer->SetMaximumIncomingConnections(numberAllowed);
}

- (BOOL)active {
    return self.peer->IsActive();
}

#pragma mark Initializers

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.peer = RakPeerInterface::GetInstance();
        if (self.peer == nil) {
            return nil;
        }
    }
    
    return self;
}

#pragma mark ---

- (BOOL)startupWithMaxConnectionsAllowed:(unsigned int)maxConnections socketDescriptor:(RNSocketDescriptor *)descriptor error:(out NSError **)error {
    StartupResult result = self.peer->Startup(maxConnections, descriptor.socketDescriptor, 1);
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
        
        *error = [NSError errorWithDomain:RNWrapperErrorDomain code:result userInfo:errorDictionary];
        return NO;
    }
}

- (BOOL)startupWithMaxConnectionsAllowed:(unsigned int)maxConnections socketDescriptors:(nonnull NSArray<RNSocketDescriptor *> *)descriptors error:(out NSError * __nullable * __nullable)error {
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
        
        *error = [NSError errorWithDomain:RNWrapperErrorDomain code:result userInfo:errorDictionary];
        return NO;
    }
}

- (void)shutdownWithDuration:(unsigned int)blockDuration {
    self.peer->Shutdown(blockDuration);
}

- (BOOL)connectToHost:(nonnull NSString *)host remotePort:(unsigned short)remotePort error:(out NSError * __nullable * __nullable)error {
    int result = self.peer->Connect([host UTF8String], remotePort, 0, 0);
    
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
        
        *error = [NSError errorWithDomain:RNWrapperErrorDomain code:result userInfo:errorDictionary];
        return NO;
    }
}

- (void)closeConnectionWithGUID:(unsigned long long)guid sendNotification:(BOOL)sendNotification {
    RakNetGUID rakNetGUID = [self getRakNetGUIDFromValue:guid];
    self.peer->CloseConnection(rakNetGUID, sendNotification);
}

- (void)closeConnectionWithAddress:(nonnull RNSystemAddress *)address sendNotification:(BOOL)sendNotification {
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

- (nonnull NSArray *)getConnectionListWithNumberOfSystems:(unsigned short)numberOfSystems {
    SystemAddress *systems = new SystemAddress[numberOfSystems];
    self.peer->GetConnectionList(systems, &numberOfSystems);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:numberOfSystems];
    
    for (int i = 0; i < numberOfSystems; i++) {
        SystemAddress address = systems[i];
        [array addObject:[[RNSystemAddress alloc] initWithSystemAddress:address]];
    }
    
    delete [] systems;
    
    return array;
}

- (unsigned long long)getMyGUID {
    RakNetGUID guid = self.peer->GetMyGUID();
    return (unsigned long long)guid.g;
}

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

- (unsigned int)getNumberOfAddresses {
    return self.peer->GetNumberOfAddresses();
}

- (nullable NSString *)getLocalIPWithIndex:(unsigned int)index {
    const char *address = self.peer->GetLocalIP(index);

    if (strcmp(address, UNASSIGNED_SYSTEM_ADDRESS.ToString()) == 0) {
        return nil;
    } else {
        return [NSString stringWithUTF8String:address];
    }
}

- (unsigned short)numberOfConnections {
    return self.peer->NumberOfConnections();
}

- (void)setOfflinePingResponse:(nullable NSData *)data {
    unsigned int length = data != nil ? [data length] : 0;
    const char *bytes = (const char *)[data bytes];
    
    self.peer->SetOfflinePingResponse(bytes, length);
}

- (nullable NSData *)getOfflinePingResponse {
    char *data = 0;
    unsigned int length = 0;
    
    self.peer->GetOfflinePingResponse(&data, &length);
    
    if (data == 0) {
        return nil;
    } else {
        return [NSData dataWithBytes:data length:length];
    }
}

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
