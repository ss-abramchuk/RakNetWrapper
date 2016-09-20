//
//  RNBitStream.h
//  MCPEServer
//
//  Created by Sergey Abramchuk on 15.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNBitStreamType.h"

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


#pragma mark Initializers

/**
 *  Initialize the bitstream.
 *
 *  @return RNBitStream instance
 */
- (nonnull instancetype)init;

/**
 *  Initialize the bitstream with existing data.
 *
 *  @param data <#data description#>
 *  @param copy true or false to make a copy of data or not.
 *
 *  @return RNBitStream instance
 */
- (nonnull instancetype)initWithData:(nonnull NSData *)data copy:(BOOL)copy;

/**
 *  Resets the bitstream for reuse.
 */
- (void)reset;

/**
 *  Ignore data we don't intend to read.
 *
 *  @param numberOfBytes The number of bytes to ignore.
 */
- (void)ignoreBytes:(NSUInteger)numberOfBytes;

/**
 *  Sets the read pointer back to the beginning of your data.
 */
- (void)resetReadPointer;

/**
 *  Sets the write pointer back to the beginning of your data.
 */
- (void)resetWritePointer;


/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (NSUInteger)getWriteOffset;

- (void)setWriteOffset:(NSUInteger)offset;

/**
 *  <#Description#>
 *
 *  @param value <#value description#>
 *  @param type  <#type description#>
 */
- (void)writeNumericValue:(nonnull NSNumber *)value ofType:(RNBitStreamType)type;

/**
 *  <#Description#>
 *
 *  @param value <#value description#>
 *  @param type  <#type description#>
 *  @param error <#error description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)readNumericValue:(out NSNumber * __nullable * __nullable)value ofType:(RNBitStreamType)type error:(out NSError * __nullable * __nullable)error;

/**
 *  <#Description#>
 *
 *  @param value <#value description#>
 */
- (void)writeStringValue:(nonnull NSString *)value;

/**
 *  <#Description#>
 *
 *  @param value <#value description#>
 *  @param error <#error description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)readStringValue:(out NSString * __nullable * __nullable)value error:(out NSError * __nullable * __nullable)error;

/**
 *  <#Description#>
 *
 *  @param data <#data description#>
 */
- (void)writeData:(nonnull NSData *)data;

/**
 *  <#Description#>
 *
 *  @param data   <#data description#>
 *  @param length <#length description#>
 *  @param error  <#error description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)readData:(out NSData * __nullable * __nullable)data withLength:(NSInteger)length error:(out NSError * __nullable * __nullable)error;

@end
