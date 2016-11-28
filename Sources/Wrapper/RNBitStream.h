//
//  RNBitStream.h
//  MCPEServer
//
//  Created by Sergey Abramchuk on 15.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO: Add descriptions to methods

/**
 RNBitStream allows you to write and read native types as bytes.
 */
@interface RNBitStream : NSObject

#pragma mark Properties

/**
 Gets the data that RNBitStream is writing to / reading from.
 */
@property (readonly, nonnull) NSData *data;

/**
 The number of bytes into the stream that we have read.
 */
@property (nonatomic) NSUInteger readOffset;

/**
 The number of bytes into the stream that we have written.
 */
@property (nonatomic) NSUInteger writeOffset;


#pragma mark Initializers

/**
 Initialize the bitstream.

 @return RNBitStream instance
 */
- (nonnull instancetype)init;

/**
 Initialize the bitstream with existing data.

 @param data <#data description#>
 @param copy YES or NO to make a copy of data or not.

 @return RNBitStream instance
 */
- (nonnull instancetype)initWithData:(nonnull NSData *)data copy:(BOOL)copy;


#pragma mark Pointers

/**
 Resets the bitstream for reuse.
 */
- (void)reset;

/**
 Ignore data we don't intend to read.
 
 @param numberOfBytes The number of bytes to ignore.
 */
- (void)ignoreBytes:(NSUInteger)numberOfBytes;

/**
 Sets the read pointer back to the beginning of your data.
 */
- (void)resetReadPointer;

/**
 Sets the write pointer back to the beginning of your data.
 */
- (void)resetWritePointer;


#pragma mark Read / Write

- (void)writeBool:(BOOL)value
NS_SWIFT_NAME(write(value:));

- (void)writeUInt8:(uint8_t)value
NS_SWIFT_NAME(write(value:));

- (void)writeInt8:(int8_t)value
NS_SWIFT_NAME(write(value:));

- (void)writeAlignedInt8:(int8_t)value
NS_SWIFT_NAME(writeAligned(value:));

- (void)writeAlignedUInt8:(uint8_t)value
NS_SWIFT_NAME(writeAligned(value:));

- (void)writeUInt16:(uint16_t)value
NS_SWIFT_NAME(write(value:));

- (void)writeInt16:(int16_t)value
NS_SWIFT_NAME(write(value:));

- (void)writeAlignedInt16:(int16_t)value
NS_SWIFT_NAME(writeAligned(value:));

- (void)writeAlignedUInt16:(uint16_t)value
NS_SWIFT_NAME(writeAligned(value:));

- (void)writeUInt32:(uint32_t)value
NS_SWIFT_NAME(write(value:));

- (void)writeInt32:(int32_t)value
NS_SWIFT_NAME(write(value:));

- (void)writeAlignedInt32:(int32_t)value
NS_SWIFT_NAME(writeAligned(value:));

- (void)writeAlignedUInt32:(uint32_t)value
NS_SWIFT_NAME(writeAligned(value:));

- (void)writeUInt64:(uint64_t)value
NS_SWIFT_NAME(write(value:));

- (void)writeInt64:(int64_t)value
NS_SWIFT_NAME(write(value:));

- (void)writeFloat:(float)value
NS_SWIFT_NAME(write(value:));

- (void)writeDouble:(double)value
NS_SWIFT_NAME(write(value:));

- (void)writeString:(nonnull NSString *)value
NS_SWIFT_NAME(write(value:));

- (void)writeData:(nonnull NSData *)data
NS_SWIFT_NAME(write(value:));

- (BOOL)readBool:(out nonnull BOOL *)value
           error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(read(value:));

- (BOOL)readUInt8:(out nonnull uint8_t *)value
            error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(read(value:));

- (BOOL)readInt8:(out nonnull int8_t *)value
                 error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(read(value:));

- (BOOL)readAlignedInt8:(out nonnull int8_t *)value
               error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(readAligned(value:));

- (BOOL)readAlignedUInt8:(out nonnull uint8_t *)value
              error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(readAligned(value:));

- (BOOL)readUInt16:(out nonnull uint16_t *)value
                 error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(read(value:));

- (BOOL)readInt16:(out nonnull int16_t *)value
                error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(read(value:));

- (BOOL)readAlignedInt16:(out nonnull int16_t *)value
               error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(readAligned(value:));

- (BOOL)readAlignedUInt16:(out nonnull uint16_t *)value
               error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(readAligned(value:));

- (BOOL)readUInt32:(out nonnull uint32_t *)value
                 error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(read(value:));

- (BOOL)readInt32:(out nonnull int32_t *)value
                error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(read(value:));

- (BOOL)readAlignedInt32:(out nonnull int32_t *)value
            error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(readAligned(value:));

- (BOOL)readAlignedUInt32:(out nonnull uint32_t *)value
               error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(readAligned(value:));

- (BOOL)readCompressedUInt32:(out nonnull uint32_t *)value
                    error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(readCompressed(value:));

- (BOOL)readCompressedInt32:(out nonnull int32_t *)value
                       error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(readCompressed(value:));

- (BOOL)readVarInt32:(out nonnull int32_t *)value
                error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(readVar(value:));

- (BOOL)readVarUInt32:(out nonnull uint32_t *)value
                error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(readVar(value:));

- (BOOL)readUInt64:(out nonnull uint64_t *)value
                  error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(read(value:));

- (BOOL)readInt64:(out nonnull int64_t *)value
                 error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(read(value:));

- (BOOL)readVarInt64:(out nonnull int64_t *)value
               error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(readVar(value:));

- (BOOL)readVarUInt64:(out nonnull uint64_t *)value
                error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(readVar(value:));

- (BOOL)readFloat:(out nonnull float *)value
                  error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(read(value:));

- (BOOL)readDouble:(out nonnull double *)value
                 error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(read(value:));

- (BOOL)readString:(out NSString * __nullable * __nonnull)value error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(read(value:));

- (BOOL)readData:(out NSData * __nullable * __nonnull)data withLength:(NSInteger)length error:(out NSError * __nullable * __nullable)error
NS_SWIFT_NAME(read(value:length:));

@end
