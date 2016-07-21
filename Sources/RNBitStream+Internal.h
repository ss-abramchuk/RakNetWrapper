//
//  RNBitStream+Internal.h
//  MCPEServer
//
//  Created by Sergey Abramchuk on 11.02.16.
//  Copyright © 2016 ss-abramchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BitStream.h"
#import "RNBitStream.h"

using namespace RakNet;

@interface RNBitStream (Internal)

@property (nonatomic, assign, readonly) BitStream *bitStream;

@end
