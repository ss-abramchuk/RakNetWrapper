//
//  RNSocketDescriptor.m
//  MCPEServer
//
//  Created by Sergey Abramchuk on 13.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import "RNSocketDescriptor.h"

#import "RNSocketDescriptor+Internal.h"

#include <string.h>

using namespace RakNet;

@interface RNSocketDescriptor () {
    SocketDescriptor *_socketDescriptor;
}

@end

@implementation RNSocketDescriptor (Internal)

- (SocketDescriptor *)socketDescriptor {
    return _socketDescriptor;
}

@end

@implementation RNSocketDescriptor

- (nonnull instancetype)init {
    self = [super init];
    
    if (self) {
        _socketDescriptor = new SocketDescriptor();
    }
    
    return self;
}

- (nonnull instancetype)initWithPort:(unsigned short)port andAddress:(nullable NSString *)address {
    self = [super init];
    
    if (self) {
        _socketDescriptor = new SocketDescriptor(port, address != nil ? [address UTF8String] : "");
    }
    
    return self;
}


- (unsigned short)port {
    return self.socketDescriptor->port;
}

- (void)setPort:(unsigned short)port {
    self.socketDescriptor->port = port;
}

- (NSString *)address {
    return [NSString stringWithUTF8String:self.socketDescriptor->hostAddress];
}

- (void)setAddress:(NSString *)address {
    const char *hostAddress = address != nil ? [address UTF8String] : 0;
    strncpy(self.socketDescriptor->hostAddress, hostAddress, sizeof(self.socketDescriptor->hostAddress) - 1);
}

- (RNSocketFamily)socketFamily {
    switch (self.socketDescriptor->socketFamily) {
        case AF_INET:
            return RNSocketFamilyIPV4;
            
        case AF_INET6:
            return RNSocketFamilyIPV6;
            
        default:
            return RNSocketFamilyUnspecified;
    }
}

- (void)setSocketFamily:(RNSocketFamily)socketFamily {
    switch (socketFamily) {
        case RNSocketFamilyIPV4:
            self.socketDescriptor->socketFamily = AF_INET;
            break;
            
        case RNSocketFamilyIPV6:
            self.socketDescriptor->socketFamily = AF_INET6;
            break;
            
        default:
            self.socketDescriptor->socketFamily = AF_UNSPEC;
            break;
    }
}

- (BOOL)blockingSocket {
    return self.socketDescriptor->blockingSocket;
}

- (void)setBlockingSocket:(BOOL)blockingSocket {
    self.socketDescriptor->blockingSocket = blockingSocket;
}

- (void)dealloc {
    delete self.socketDescriptor;
}

@end
