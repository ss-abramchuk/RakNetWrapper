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

#pragma mark Properties

- (NSData *)data {
    unsigned char * data = _bitStream->GetData();
    NSUInteger length = _bitStream->GetNumberOfBytesUsed();
    
    return [NSData dataWithBytes:data length:length];
}

- (NSUInteger)readOffset {
    BitSize_t offset = _bitStream->GetReadOffset();
    return BITS_TO_BYTES(offset);
}

- (void)setReadOffset:(NSUInteger)offset {
    BitSize_t newOffset = BYTES_TO_BITS(offset);
    _bitStream->SetReadOffset(newOffset);
}

- (NSUInteger)writeOffset {
    BitSize_t offset = _bitStream->GetWriteOffset();
    return BITS_TO_BYTES(offset);
}

- (void)setWriteOffset:(NSUInteger)offset {
    BitSize_t newOffset = BYTES_TO_BITS(offset);
    _bitStream->SetWriteOffset(newOffset);
}


#pragma mark Initializers

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


#pragma mark Pointers

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

#pragma mark Read / Write

- (void)writeBool:(BOOL)value {
    _bitStream->Write(value);
}

- (void)writeUInt8:(uint8_t)value {
    _bitStream->Write(value);
}

- (void)writeInt8:(int8_t)value {
    _bitStream->Write(value);
}

- (void)writeAlignedInt8:(int8_t)value {
    char bytes[sizeof(int8_t)];
    *reinterpret_cast<int8_t *>(bytes) = value;
    
    _bitStream->WriteAlignedVar8(bytes);
}

- (void)writeAlignedUInt8:(uint8_t)value {
    char bytes[sizeof(uint8_t)];
    *reinterpret_cast<uint8_t *>(bytes) = value;
    
    _bitStream->WriteAlignedVar8(bytes);
}

- (void)writeUInt16:(uint16_t)value {
    _bitStream->Write(value);
}

- (void)writeInt16:(int16_t)value {
    _bitStream->Write(value);
}

- (void)writeAlignedInt16:(int16_t)value {
    char bytes[sizeof(int16_t)];
    *reinterpret_cast<int16_t *>(bytes) = value;
    
    _bitStream->WriteAlignedVar16(bytes);
}

- (void)writeAlignedUInt16:(uint16_t)value {
    char bytes[sizeof(uint16_t)];
    *reinterpret_cast<uint16_t *>(bytes) = value;
    
    _bitStream->WriteAlignedVar16(bytes);
}

- (void)writeUInt32:(uint32_t)value {
    _bitStream->Write(value);
}

- (void)writeInt32:(int32_t)value {
    _bitStream->Write(value);
}

- (void)writeVarUInt32:(uint32_t)value {
    while (value & 0xFFFFFF80) {
        uint8_t byte = (uint8_t)((value & 0x7F) | 0x80);
        _bitStream->Write(byte);
        
        value >>= 7;
    }

    _bitStream->Write((uint8_t)value);
}

- (void)writeVarInt32:(int32_t)value {
    [self writeVarUInt32:(uint32_t)value];
}

- (void)writeAlignedInt32:(int32_t)value {
    char bytes[sizeof(int32_t)];
    *reinterpret_cast<int32_t *>(bytes) = value;
    
    _bitStream->WriteAlignedVar32(bytes);
}

- (void)writeAlignedUInt32:(uint32_t)value {
    char bytes[sizeof(uint32_t)];
    *reinterpret_cast<uint32_t *>(bytes) = value;
    
    _bitStream->WriteAlignedVar32(bytes);
}

- (void)writeUInt64:(uint64_t)value {
    _bitStream->Write(value);
}

- (void)writeInt64:(int64_t)value {
    _bitStream->Write(value);
}

- (void)writeVarUInt64:(uint64_t)value {
    while (value & 0xFFFFFF80) {
        uint8_t byte = (uint8_t)((value & 0x7F) | 0x80);
        _bitStream->Write(byte);
        
        value >>= 7;
    }
    
    _bitStream->Write((uint8_t)value);
}

- (void)writeVarInt64:(int64_t)value {
    [self writeVarUInt32:(uint64_t)value];
}

- (void)writeFloat:(float)value {
    _bitStream->Write(value);
}

- (void)writeDouble:(double)value {
    _bitStream->Write(value);
}

- (void)writeString:(nonnull NSString *)value {
    RakString rakString(value.UTF8String);
    _bitStream->Write(rakString);
}

- (void)writeData:(NSData *)data {
    _bitStream->Write((const char *)data.bytes, data.length);
}

- (BOOL)readBool:(out nonnull BOOL *)value
                 error:(out NSError * __nullable * __nullable)error {
    if (_bitStream->Read(*value)) {
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                     code:0
                                 userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read Bool value" }];
        return NO;
    }
}

- (BOOL)readUInt8:(out nonnull uint8_t *)value
                 error:(out NSError * __nullable * __nullable)error {
    if (_bitStream->Read(*value)) {
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                     code:0
                                 userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read UInt8 value" }];
        return NO;
    }
}

- (BOOL)readInt8:(out nonnull int8_t *)value
                error:(out NSError * __nullable * __nullable)error {
    if (_bitStream->Read(*value)) {
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                     code:0
                                 userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read Int8 value" }];
        return NO;
    }
}

- (BOOL)readAlignedInt8:(out nonnull int8_t *)value
               error:(out NSError * __nullable * __nullable)error {
    int size = sizeof(int8_t);
    char bytes[size];
    
    if (_bitStream->ReadAlignedVar8(bytes)) {
        *value = *reinterpret_cast<int8_t *>(bytes);
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                                code:0
                                            userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read aligned Int8 value" }];
        return NO;
    }
}

- (BOOL)readAlignedUInt8:(out nonnull uint8_t *)value
              error:(out NSError * __nullable * __nullable)error {
    int size = sizeof(uint8_t);
    char bytes[size];
    
    if (_bitStream->ReadAlignedVar8(bytes)) {
        *value = *reinterpret_cast<uint8_t *>(bytes);
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                                code:0
                                            userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read aligned UInt8 value" }];
        return NO;
    }
}

- (BOOL)readUInt16:(out nonnull uint16_t *)value
                  error:(out NSError * __nullable * __nullable)error {
    if (_bitStream->Read(*value)) {
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                     code:0
                                 userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read UInt16 value" }];
        return NO;
    }
}

- (BOOL)readInt16:(out nonnull int16_t *)value
                 error:(out NSError * __nullable * __nullable)error {
    if (_bitStream->Read(*value)) {
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                     code:0
                                 userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read Int16 value" }];
        return NO;
    }
}

- (BOOL)readAlignedInt16:(out nonnull int16_t *)value
              error:(out NSError * __nullable * __nullable)error {
    int size = sizeof(int16_t);
    char bytes[size];
    
    if (_bitStream->ReadAlignedVar16(bytes)) {
        *value = *reinterpret_cast<int16_t *>(bytes);
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                                code:0
                                            userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read aligned Int16 value" }];
        return NO;
    }
}

- (BOOL)readAlignedUInt16:(out nonnull uint16_t *)value
               error:(out NSError * __nullable * __nullable)error {
    int size = sizeof(uint16_t);
    char bytes[size];
    
    if (_bitStream->ReadAlignedVar16(bytes)) {
        *value = *reinterpret_cast<uint16_t *>(bytes);
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                                code:0
                                            userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read aligned UInt16 value" }];
        return NO;
    }
}

- (BOOL)readUInt32:(out nonnull uint32_t *)value
                  error:(out NSError * __nullable * __nullable)error {
    if (_bitStream->Read(*value)) {
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                     code:0
                                 userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read UInt32 value" }];
        return NO;
    }
}

- (BOOL)readInt32:(out nonnull int32_t *)value
                 error:(out NSError * __nullable * __nullable)error {
    if (_bitStream->Read(*value)) {
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                     code:0
                                 userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read Int32 value" }];
        return NO;
    }
}

- (BOOL)readAlignedInt32:(out nonnull int32_t *)value
               error:(out NSError * __nullable * __nullable)error {
    int size = sizeof(int32_t);
    char bytes[size];
    
    if (_bitStream->ReadAlignedVar32(bytes)) {
        *value = *reinterpret_cast<int32_t *>(bytes);
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                                code:0
                                            userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read aligned Int32 value" }];
        return NO;
    }
}

- (BOOL)readAlignedUInt32:(out nonnull uint32_t *)value
               error:(out NSError * __nullable * __nullable)error {
    int size = sizeof(uint32_t);
    char bytes[size];
    
    if (_bitStream->ReadAlignedVar32(bytes)) {
        *value = *reinterpret_cast<uint32_t *>(bytes);
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                                code:0
                                            userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read aligned UInt32 value" }];
        return NO;
    }
}

- (BOOL)readCompressedUInt32:(out nonnull uint32_t *)value
                       error:(out NSError * __nullable * __nullable)error{
    if (_bitStream->ReadCompressed(*value)) {
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                                code:0
                                            userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read compressed UInt32 value" }];
        return NO;
    }
}

- (BOOL)readCompressedInt32:(out nonnull int32_t *)value
                      error:(out NSError * __nullable * __nullable)error {
    if (_bitStream->ReadCompressed(*value)) {
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                                code:0
                                            userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read compressed UInt32 value" }];
        return NO;
    }
}

- (BOOL)readVarInt32:(out nonnull int32_t *)value
                error:(out NSError * __nullable * __nullable)error {
    int32_t result = 0;
    
    char bytesMax = 5;
    char bytesRead = 0;
    
    int8_t byte = 0;
    
    do {
        if ((bytesRead > bytesMax) || !_bitStream->Read(byte)) {
            if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                                    code:0
                                                userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read var Int32 value" }];
            return NO;
        }
        
        result |= (byte & 0x7F) << bytesRead * 7;
        
        bytesRead++;
    } while (byte & 0x80);
    
    *value = result;
    
    return YES;
}

- (BOOL)readVarUInt32:(out nonnull uint32_t *)value
               error:(out NSError * __nullable * __nullable)error {
    uint32_t result = 0;
    
    char bytesMax = 5;
    char bytesRead = 0;
    
    uint8_t byte = 0;
    
    do {
        if ((bytesRead > bytesMax) || !_bitStream->Read(byte)) {
            if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                                    code:0
                                                userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read var UInt32 value" }];
            return NO;
        }
        
        result |= (byte & 0x7F) << bytesRead * 7;
        
        bytesRead++;
    } while (byte & 0x80);
    
    *value = result;
    
    return YES;
}

- (BOOL)readUInt64:(out nonnull uint64_t *)value
                  error:(out NSError * __nullable * __nullable)error {
    if (_bitStream->Read(*value)) {
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                     code:0
                                 userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read UInt64 value" }];
        return NO;
    }
}

- (BOOL)readInt64:(out nonnull int64_t *)value
                 error:(out NSError * __nullable * __nullable)error {
    if (_bitStream->Read(*value)) {
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                     code:0
                                 userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read Int64 value" }];
        return NO;
    }
}

- (BOOL)readVarInt64:(out nonnull int64_t *)value
               error:(out NSError * __nullable * __nullable)error {
    int64_t result = 0;
    
    char bytesMax = 10;
    char bytesRead = 0;
    
    int8_t byte = 0;
    
    do {
        if ((bytesRead > bytesMax) || !_bitStream->Read(byte)) {
            if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                                    code:0
                                                userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read var Int64 value" }];
            return NO;
        }
        
        result |= (byte & 0x7F) << bytesRead * 7;
        
        bytesRead++;
    } while (byte & 0x80);
    
    *value = result;
    
    return YES;
}

- (BOOL)readVarUInt64:(out nonnull uint64_t *)value
               error:(out NSError * __nullable * __nullable)error {
    uint64_t result = 0;
    
    char bytesMax = 10;
    char bytesRead = 0;
    
    int8_t byte = 0;
    
    do {
        if ((bytesRead > bytesMax) || !_bitStream->Read(byte)) {
            if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                                    code:0
                                                userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read var UInt64 value" }];
            return NO;
        }
        
        result |= (byte & 0x7F) << bytesRead * 7;
        
        bytesRead++;
    } while (byte & 0x80);
    
    *value = result;
    
    return YES;
}

- (BOOL)readFloat:(out nonnull float *)value
                 error:(out NSError * __nullable * __nullable)error {
    if (_bitStream->Read(*value)) {
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                     code:0
                                 userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read Float value" }];
        return NO;
    }
}

- (BOOL)readDouble:(out nonnull double *)value
                  error:(out NSError * __nullable * __nullable)error {
    if (_bitStream->Read(*value)) {
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain
                                     code:0
                                 userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read Double value" }];
        return NO;
    }
}

- (BOOL)readString:(out NSString * __nullable * __nonnull)value error:(out NSError * __nullable * __nullable)error {
    RakString rakString;
    if (_bitStream->Read(rakString)) {
        *value = [NSString stringWithUTF8String:rakString.C_String()];
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain code:0 userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read String value" }];
        return NO;
    }
}

- (BOOL)readData:(out NSData * __nullable * __nonnull)data withLength:(NSInteger)length error:(out NSError * __nullable * __nullable)error {
    char result[length];
    if (_bitStream->Read(result, length)) {
        *data = [NSData dataWithBytes:result length:length];
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:RNWrapperErrorDomain code:0 userInfo:@{ NSLocalizedDescriptionKey : @"Couldn't read Data value" }];
        return NO;
    }
}

- (void)dealloc {
    BitStream::DestroyInstance(self.bitStream);
}

@end
