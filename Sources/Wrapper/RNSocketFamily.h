//
//  IPVersions.h
//  MCPEServer
//
//  Created by Sergey Abramchuk on 13.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(short, RNSocketFamily) {
    RNSocketFamilyIPV4,
    RNSocketFamilyIPV6,
    RNSocketFamilyUnspecified
};
