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
    unsigned long long _guid;
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

- (unsigned long long)guid {
    return _guid;
}

- (unsigned char)identifier {
    unsigned char *bytes = (unsigned char *)_data.bytes;
    if (bytes[0] == ID_TIMESTAMP) {
        return bytes[sizeof(MessageID) + sizeof(RakNet::Time)];
    } else {
        return bytes[0];
    }
}

- (unsigned int)offset {
    unsigned char *bytes = (unsigned char *)_data.bytes;
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
