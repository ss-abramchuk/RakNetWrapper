//
//  RNPacket.m
//  MCPEServer
//
//  Created by Sergey Abramchuk on 29.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import "RNPacket+Internal.h"
#import "RNSystemAddress.h"
#import "RNSystemAddress+Internal.h"

#import "MessageIdentifiers.h"

@interface RNPacket () {
    RNSystemAddress *_systemAddress;
    uint64_t _guid;
    NSData *_data;
}

@end

@implementation RNPacket (Internal)

- (instancetype)initWithPacket:(Packet *)packet {
    self = [super init];
    if (self) {
        _systemAddress = [[RNSystemAddress alloc] initWithSystemAddress:packet->systemAddress];
        _guid = packet->guid.g;
        _data = [NSData dataWithBytes:packet->data length:packet->length];
    }
    return self;
}

@end

@implementation RNPacket

- (RNSystemAddress *)systemAddress {
    return _systemAddress;
}

- (uint64_t)guid {
    return _guid;
}

- (uint8_t)identifier {
    uint8_t *bytes = (uint8_t *)_data.bytes;
    if (bytes[0] == ID_TIMESTAMP) {
        return bytes[sizeof(MessageID) + sizeof(RakNet::Time)];
    } else {
        return bytes[0];
    }
}

- (uint32_t)offset {
    uint32_t *bytes = (uint32_t *)_data.bytes;
    if (bytes[0] == ID_TIMESTAMP) {
        return sizeof(MessageID) + sizeof(RakNet::Time);
    } else {
        return 0;
    }
}

- (NSData *)data {
    return _data;
}

@end
