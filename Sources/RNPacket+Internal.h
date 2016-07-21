//
//  RNPacket+Internal.h
//  MCPEServer
//
//  Created by Sergey Abramchuk on 29.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import "RNPacket.h"

#import "RakNetTypes.h"

using namespace RakNet;

@interface RNPacket (Internal)

- (instancetype)initWithPacket:(Packet *)packet;

@end