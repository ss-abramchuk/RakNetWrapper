//
//  RNSystemAddress+Internal.h
//  MCPEServer
//
//  Created by Sergey Abramchuk on 24.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import "RNSystemAddress.h"

#import "RakNetTypes.h"

using namespace RakNet;

@interface RNSystemAddress (Internal)

@property (nonatomic, assign, readonly) SystemAddress *systemAddress;

- (instancetype)initWithSystemAddress:(SystemAddress)systemAddress;

@end