//
//  RNBitStream.m
//  MCPEServer
//
//  Created by Sergey Abramchuk on 15.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import "RNConstants.h"
#import "RNBitStream+Internal.h"

@interface RNBitStream () {
    BitStream *_bitStream;
}

@end

@implementation RNBitStream (Internal)

- (BitStream *)bitStream {
    return _bitStream;
}

@end

@implementation RNBitStream

- (NSData *)data {
    unsigned char * data = _bitStream->GetData();
    NSUInteger length = _bitStream->GetNumberOfBytesUsed();
    
    return [NSData dataWithBytes:data length:length];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _bitStream = new BitStream();
    }
    
    return self;
}

- (nonnull instancetype)initWithData:(nonnull NSData *)data copy:(BOOL)copy {
    self = [super init];
    
    if (self) {
        _bitStream = new BitStream((unsigned char*)data.bytes, data.length, copy);
    }
    
    return self;
}

- (void)reset {
    _bitStream->Reset();
}

- (void)ignoreBytes:(NSUInteger)numberOfBytes {
    _bitStream->IgnoreBytes(numberOfBytes);
}

- (void)resetReadPointer {
    _bitStream->ResetReadPointer();
}

- (void)resetWritePointer {
    _bitStream->ResetWritePointer();
}

- (NSUInteger)getReadOffset {
    BitSize_t offset = _bitStream->GetReadOffset();
    return BITS_TO_BYTES(offset);
}

- (NSUInteger)getWriteOffset {
    BitSize_t offset = _bitStream->GetWriteOffset();
    return BITS_TO_BYTES(offset);
}

- (void)setReadOffset:(NSUInteger)offset {
    BitSize_t newOffset = BYTES_TO_BITS(offset);
    _bitStream->SetReadOffset(newOffset);
}

- (void)setWriteOffset:(NSUInteger)offset {
    BitSize_t newOffset = BYTES_TO_BITS(offset);
    _bitStream->SetWriteOffset(newOffset);
}

- (void)writeNumericValue:(nonnull NSNumber *)value ofType:(RNBitStreamType)type {
    switch (type) {
        case RNBitStreamTypeBool:
            _bitStream->Write(value.boolValue);
            break;
            
        case RNBitStreamTypeChar:
            _bitStream->Write(value.charValue);
            break;
            
        case RNBitStreamTypeUnsignedChar:
            _bitStream->Write(value.unsignedCharValue);
            break;
            
        case RNBitStreamTypeShort:
            _bitStream->Write(value.shortValue);
            break;
            
        case RNBitStreamTypeUnsignedShort:
            _bitStream->Write(value.unsignedShortValue);
            break;
            
        case RNBitStreamTypeInt:
            _bitStream->Write(value.intValue);
            break;
            
        case RNBitStreamTypeUnsignedInt:
            _bitStream->Write(value.unsignedIntValue);
            break;
            
        case RNBitStreamTypeLong:
            _bitStream->Write(value.longValue);
            break;
            
        case RNBitStreamTypeUnsignedLong:
            _bitStream->Write(value.unsignedLongValue);
            break;
            
        case RNBitStreamTypeLongLong:
            _bitStream->Write(value.longLongValue);
            break;
            
        case RNBitStreamTypeUnsignedLongLong:
            _bitStream->Write(value.unsignedLongLongValue);
            break;
            
        case RNBitStreamTypeFloat:
            _bitStream->Write(value.floatValue);
            break;
            
        case RNBitStreamTypeDouble:
            _bitStream->Write(value.doubleValue);
            break;
    }
}

- (BOOL)readNumericValue:(out NSNumber * __nullable * __nullable)value ofType:(RNBitStreamType)type error:(out NSError * __nullable * __nullable)error {
    NSInteger code = type;
    NSDictionary *errorDictionary = nil;
    
    switch (type) {
        case RNBitStreamTypeBool: {
            BOOL result = NO;
            if (_bitStream->Read(result)) {
                *value = [NSNumber numberWithBool:result];
            } else {
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Couldn't read BOOL value" };
            }
        } break;
            
        case RNBitStreamTypeChar: {
            char result = 0;
            if (_bitStream->Read(result)) {
                *value = [NSNumber numberWithChar:result];
            } else {
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Couldn't read char value" };
            }
        } break;
            
        case RNBitStreamTypeUnsignedChar: {
            unsigned char result = 0;
            if (_bitStream->Read(result)) {
                *value = [NSNumber numberWithUnsignedChar:result];
            } else {
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Couldn't read unsigned char value" };
            }
        } break;
        
        case RNBitStreamTypeShort: {
            short result = 0;
            if (_bitStream->Read(result)) {
                *value = [NSNumber numberWithShort:result];
            } else {
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Couldn't read short value" };
            }
        } break;
        
        case RNBitStreamTypeUnsignedShort: {
            unsigned short result = 0;
            if (_bitStream->Read(result)) {
                *value = [NSNumber numberWithUnsignedShort:result];
            } else {
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Couldn't read unsigned short value" };
            }
        } break;
        
        case RNBitStreamTypeInt: {
            int result = 0;
            if (_bitStream->Read(result)) {
                *value = [NSNumber numberWithInt:result];
            } else {
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Couldn't read int value" };
            }
        } break;
            
        case RNBitStreamTypeUnsignedInt: {
            unsigned int result = 0;
            if (_bitStream->Read(result)) {
                *value = [NSNumber numberWithUnsignedInt:result];
            } else {
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Couldn't read unsigned int value" };
            }
        } break;
        
        case RNBitStreamTypeLong: {
            long result = 0;
            if (_bitStream->Read(result)) {
                *value = [NSNumber numberWithLong:result];
            } else {
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Couldn't read long value" };
            }
        } break;
            
        case RNBitStreamTypeUnsignedLong: {
            unsigned long result = 0;
            if (_bitStream->Read(result)) {
                *value = [NSNumber numberWithUnsignedLong:result];
            } else {
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Couldn't read unsigned long value" };
            }
        } break;
            
        case RNBitStreamTypeLongLong: {
            long long result = 0;
            if (_bitStream->Read(result)) {
                *value = [NSNumber numberWithLongLong:result];
            } else {
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Couldn't read long long value" };
            }
        } break;
            
        case RNBitStreamTypeUnsignedLongLong: {
            unsigned long long result = 0;
            if (_bitStream->Read(result)) {
                *value = [NSNumber numberWithUnsignedLongLong:result];
            } else {
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Couldn't read unsigned long long value" };
            }
        } break;
            
        case RNBitStreamTypeFloat: {
            float result = 0.0;
            if (_bitStream->Read(result)) {
                *value = [NSNumber numberWithFloat:result];
            } else {
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Couldn't read float value" };
            }
        } break;
            
        case RNBitStreamTypeDouble: {
            double result = 0.0;
            if (_bitStream->Read(result)) {
                *value = [NSNumber numberWithDouble:result];
            } else {
                errorDictionary = @{ NSLocalizedDescriptionKey : @"Couldn't read double value" };
            }
        } break;
    }
    
    if (errorDictionary != nil) {
        *error = [NSError errorWithDomain:RNWrapperErrorDomain code:code userInfo:errorDictionary];
        return NO;
    } else {
        return YES;
    }
}

- (void)writeStringValue:(nonnull NSString *)value {
    RakString rakString(value.UTF8String);
    _bitStream->Write(rakString);
}

- (BOOL)readStringValue:(out NSString * __nullable * __nullable)value error:(out NSError * __nullable * __nullable)error {
    RakString rakString;
    if (_bitStream->Read(rakString)) {
        *value = [NSString stringWithUTF8String:rakString.C_String()];
        return YES;
    } else {
        *error = [NSError errorWithDomain:RNWrapperErrorDomain code:1 userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read string value" }];
        return NO;
    }
}

- (void)writeData:(NSData *)data {
    _bitStream->Write((const char *)data.bytes, data.length);
}

- (BOOL)readData:(out NSData * __nullable * __nullable)data withLength:(NSInteger)length error:(out NSError * __nullable * __nullable)error {
    char result[length];
    if (_bitStream->Read(result, length)) {
        *data = [NSData dataWithBytes:result length:length];
        return YES;
    } else {
        *error = [NSError errorWithDomain:RNWrapperErrorDomain code:1 userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read data value" }];
        return NO;
    }
}

- (void)dealloc {
    BitStream::DestroyInstance(self.bitStream);
}

@end
