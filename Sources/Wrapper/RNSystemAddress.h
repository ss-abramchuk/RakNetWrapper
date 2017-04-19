//
//  RNSystemAddress.h
//  MCPEServer
//
//  Created by Sergey Abramchuk on 24.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RNSocketFamily.h"

/**
 Network address for a system
 */
@interface RNSystemAddress : NSObject

/**
 Return the system address as a string
 */
@property (nonnull, nonatomic, readonly) NSString *address;

/**
 Returns the system port
 */
@property (nonatomic, readonly) uint16_t port;

- (nonnull instancetype)init;

- (nonnull instancetype)initWithAddress:(nonnull NSString *)address
NS_SWIFT_NAME(init(address:));

- (nonnull instancetype)initWithAddress:(nonnull NSString *)address andPort:(uint16_t)port
NS_SWIFT_NAME(init(address:port:));

- (BOOL)isEqual:(nullable id)object;
- (NSUInteger)hash;

@end
