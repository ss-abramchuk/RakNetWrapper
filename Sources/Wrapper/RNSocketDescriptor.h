//
//  RNSocketDescriptor.h
//  MCPEServer
//
//  Created by Sergey Abramchuk on 13.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNSocketFamily.h"

/// Describes the local socket to use for [RNPeerInterface startup:]
@interface RNSocketDescriptor : NSObject

#pragma mark Properties

/// The local port to bind to. Pass 0 to have the OS autoassign a port.
@property uint16_t port;

/// The local network card address to bind to, such as "127.0.0.1".
@property (nullable) NSString * address;

/// IP version: IPV4, IPV6. To autoselect, use Unspecified.
@property RNSocketFamily socketFamily;

// Set to true to use a blocking socket (default, do not change unless you have a reason to)
@property BOOL blockingSocket;

#pragma mark Initializers

- (nonnull instancetype)init;
- (nonnull instancetype)initWithPort:(uint16_t)port andAddress:(nullable NSString *)address
    NS_SWIFT_NAME(init(port:address:));

@end
