//
//  RNBitStreamType.h
//  MCPEServer
//
//  Created by Sergey Abramchuk on 12.02.16.
//  Copyright © 2016 ss-abramchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Numeric types supported by RNBitStream
 */
typedef NS_ENUM(unsigned char, RNBitStreamType) {
    /**
     *  This value represents BOOL
     */
    RNBitStreamTypeBool = 1,
    /**
     *  This value represents char/signed char
     */
    RNBitStreamTypeChar,
    /**
     *  This value represents unsigned char
     */
    RNBitStreamTypeUnsignedChar,
    /**
     *  This value represents short
     */
    RNBitStreamTypeShort,
    /**
     *  This value represents unsigned short
     */
    RNBitStreamTypeUnsignedShort,
    /**
     *  This value represents int
     */
    RNBitStreamTypeInt,
    /**
     *  This value represents unsigned int
     */
    RNBitStreamTypeUnsignedInt,
    /**
     *  This value represents long
     */
    RNBitStreamTypeLong,
    /**
     *  This value represents unsigned long
     */
    RNBitStreamTypeUnsignedLong,
    /**
     *  This value represents long long
     */
    RNBitStreamTypeLongLong,
    /**
     *  This value represents unsigned long long
     */
    RNBitStreamTypeUnsignedLongLong,
    /**
     *  This value represents float
     */
    RNBitStreamTypeFloat,
    /**
     *  This value represents double
     */
    RNBitStreamTypeDouble
};
