//
//  RNSocketDescriptor+HiddenProperty.h
//  MCPEServer
//
//  Created by Sergey Abramchuk on 22.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import "RNSocketDescriptor.h"

#import "RakNetTypes.h"

using namespace RakNet;

@interface RNSocketDescriptor (Internal)

@property (nonatomic, assign, readonly) SocketDescriptor *socketDescriptor;

@end
