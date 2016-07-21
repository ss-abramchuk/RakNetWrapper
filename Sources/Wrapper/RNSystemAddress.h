//
//  RNSystemAddress.h
//  MCPEServer
//
//  Created by Sergey Abramchuk on 24.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RNSocketFamily.h"

@interface RNSystemAddress : NSObject

@property (nonatomic, readonly) NSString *address;
@property (nonatomic, readonly) unsigned short port;

- (instancetype)init;
- (instancetype)initWithAddress:(NSString *)address;
- (instancetype)initWithAddress:(NSString *)address andPort:(unsigned short)port;

- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;

@end
