//
//  RNBitStreamTests.swift
//  MCPEServer
//
//  Created by Sergey Abramchuk on 12.02.16.
//  Copyright © 2016 ss-abramchuk. All rights reserved.
//

import XCTest
import RakNetWrapper

class RNBitStreamTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReadWriteBoolValue() {
        let boolValue = true
        
        let bitStream = RNBitStream()
        bitStream.writeNumericValue(NSNumber(value: boolValue), of: .bool)
        
        let data = bitStream.data
        XCTAssert(data.count == MemoryLayout<Bool>.size, "Length of data is not equal to size of bool value")
        
        do {
            var result: NSNumber? = nil
            try bitStream.readNumericValue(&result, of: .bool)
            
            XCTAssertNotNil(result, "Result is nil")
            XCTAssert(result?.boolValue == boolValue, "Result is not equal to initial bool value")
        } catch let error as NSError {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
    }
    
    func testReadWriteCharValue() {
        let charValue: CChar = 12
        
        let bitStream = RNBitStream()
        bitStream.writeNumericValue(NSNumber(value: charValue), of: .char)
        
        let data = bitStream.data
        XCTAssert(data.count == MemoryLayout<CChar>.size, "Length of data is not equal to size of char value")
        
        do {
            var result: NSNumber? = nil
            try bitStream.readNumericValue(&result, of: .char)
            
            XCTAssertNotNil(result, "Result is nil")
            XCTAssert(result?.int8Value == charValue, "Result is not equal to initial char value")
        } catch let error as NSError {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
    }
    
//    func testReadWriteUnsignedCharValue() {
//        let unsignedCharValue: CUnsignedChar = 124
//        
//        let bitStream = RNBitStream()
//        bitStream.writeNumericValue(NSNumber(unsignedChar: unsignedCharValue), ofType: .UnsignedChar)
//        
//        let data = bitStream.data
//        XCTAssert(data.length == sizeof(unsignedCharValue.dynamicType), "Length of data is not equal to size of unsigned char value")
//        
//        do {
//            var result: NSNumber? = nil
//            try bitStream.readNumericValue(&result, ofType: .UnsignedChar)
//            
//            XCTAssertNotNil(result, "Result is nil")
//            XCTAssert(result?.uint8Value == unsignedCharValue, "Result is not equal to initial unsigned char value")
//        } catch let error as NSError {
//            XCTFail("Failed with error: \(error.localizedDescription)")
//        }
//    }
//    
//    func testReadWriteShortValue() {
//        let shortValue: CShort = 6532
//        
//        let bitStream = RNBitStream()
//        bitStream.writeNumericValue(NSNumber(short: shortValue), ofType: .Short)
//        
//        let data = bitStream.data
//        XCTAssert(data.length == sizeof(shortValue.dynamicType), "Length of data is not equal to size of short value")
//        
//        do {
//            var result: NSNumber? = nil
//            try bitStream.readNumericValue(&result, ofType: .Short)
//            
//            XCTAssertNotNil(result, "Result is nil")
//            XCTAssert(result?.int16Value == shortValue, "Result is not equal to initial short value")
//        } catch let error as NSError {
//            XCTFail("Failed with error: \(error.localizedDescription)")
//        }
//    }
//    
//    func testReadWriteUnsignedShortValue() {
//        let unsignedShortValue: CUnsignedShort = 65000
//        
//        let bitStream = RNBitStream()
//        bitStream.writeNumericValue(NSNumber(unsignedShort: unsignedShortValue), ofType: .UnsignedShort)
//        
//        let data = bitStream.data
//        XCTAssert(data.length == sizeof(unsignedShortValue.dynamicType), "Length of data is not equal to size of unsigned short value")
//        
//        do {
//            var result: NSNumber? = nil
//            try bitStream.readNumericValue(&result, ofType: .UnsignedShort)
//            
//            XCTAssertNotNil(result, "Result is nil")
//            XCTAssert(result?.uint16Value == unsignedShortValue, "Result is not equal to initial unsigned short value")
//        } catch let error as NSError {
//            XCTFail("Failed with error: \(error.localizedDescription)")
//        }
//    }
//    
//    func testReadWriteIntValue() {
//        let intValue: CInt = 328644322
//        
//        let bitStream = RNBitStream()
//        bitStream.writeNumericValue(NSNumber(int: intValue), ofType: .Int)
//        
//        let data = bitStream.data
//        XCTAssert(data.length == sizeof(intValue.dynamicType), "Length of data is not equal to size of int value")
//        
//        do {
//            var result: NSNumber? = nil
//            try bitStream.readNumericValue(&result, ofType: .Int)
//            
//            XCTAssertNotNil(result, "Result is nil")
//            XCTAssert(result?.int32Value == intValue, "Result is not equal to initial int value")
//        } catch let error as NSError {
//            XCTFail("Failed with error: \(error.localizedDescription)")
//        }
//    }
//    
//    func testReadWriteUnsignedIntValue() {
//        let unsignedIntValue: CUnsignedInt = 4220843220
//        
//        let bitStream = RNBitStream()
//        bitStream.writeNumericValue(NSNumber(unsignedInt: unsignedIntValue), ofType: .UnsignedInt)
//        
//        let data = bitStream.data
//        XCTAssert(data.length == sizeof(unsignedIntValue.dynamicType), "Length of data is not equal to size of unsigned int value")
//        
//        do {
//            var result: NSNumber? = nil
//            try bitStream.readNumericValue(&result, ofType: .UnsignedInt)
//            
//            XCTAssertNotNil(result, "Result is nil")
//            XCTAssert(result?.uint32Value == unsignedIntValue, "Result is not equal to initial unsigned int value")
//        } catch let error as NSError {
//            XCTFail("Failed with error: \(error.localizedDescription)")
//        }
//    }
//    
//    func testReadWriteLongValue() {
//        let longValue: CLong = 23433577896
//        
//        let bitStream = RNBitStream()
//        bitStream.writeNumericValue(NSNumber(long: longValue), ofType: .Long)
//        
//        let data = bitStream.data
//        XCTAssert(data.length == sizeof(longValue.dynamicType), "Length of data is not equal to size of long value")
//        
//        do {
//            var result: NSNumber? = nil
//            try bitStream.readNumericValue(&result, ofType: .Long)
//            
//            XCTAssertNotNil(result, "Result is nil")
//            XCTAssert(result?.intValue == longValue, "Result is not equal to initial long value")
//        } catch let error as NSError {
//            XCTFail("Failed with error: \(error.localizedDescription)")
//        }
//    }
//    
//    func testReadWriteUnsignedLongValue() {
//        let unsignedLongValue: CUnsignedLong = 345784234423424
//        
//        let bitStream = RNBitStream()
//        bitStream.writeNumericValue(NSNumber(unsignedLong: unsignedLongValue), ofType: .UnsignedLong)
//        
//        let data = bitStream.data
//        XCTAssert(data.length == sizeof(unsignedLongValue.dynamicType), "Length of data is not equal to size of unsigned long value")
//        
//        do {
//            var result: NSNumber? = nil
//            try bitStream.readNumericValue(&result, ofType: .UnsignedLong)
//            
//            XCTAssertNotNil(result, "Result is nil")
//            XCTAssert(result?.uintValue == unsignedLongValue, "Result is not equal to initial unsigned long value")
//        } catch let error as NSError {
//            XCTFail("Failed with error: \(error.localizedDescription)")
//        }
//    }
//    
//    func testReadWriteLongLongValue() {
//        let longLongValue: CLongLong = 45542232334677
//        
//        let bitStream = RNBitStream()
//        bitStream.writeNumericValue(NSNumber(longLong: longLongValue), ofType: .LongLong)
//        
//        let data = bitStream.data
//        XCTAssert(data.length == sizeof(longLongValue.dynamicType), "Length of data is not equal to size of long long value")
//        
//        do {
//            var result: NSNumber? = nil
//            try bitStream.readNumericValue(&result, ofType: .LongLong)
//            
//            XCTAssertNotNil(result, "Result is nil")
//            XCTAssert(result?.int64Value == longLongValue, "Result is not equal to initial long long value")
//        } catch let error as NSError {
//            XCTFail("Failed with error: \(error.localizedDescription)")
//        }
//    }
//    
//    func testReadWriteUnsignedLongLongValue() {
//        let unsignedLongLongValue: CUnsignedLongLong = 33323468098283745
//        
//        let bitStream = RNBitStream()
//        bitStream.writeNumericValue(NSNumber(unsignedLongLong: unsignedLongLongValue), ofType: .UnsignedLongLong)
//        
//        let data = bitStream.data
//        XCTAssert(data.length == sizeof(unsignedLongLongValue.dynamicType), "Length of data is not equal to size of unsigned long long value")
//        
//        do {
//            var result: NSNumber? = nil
//            try bitStream.readNumericValue(&result, ofType: .UnsignedLongLong)
//            
//            XCTAssertNotNil(result, "Result is nil")
//            XCTAssert(result?.uint64Value == unsignedLongLongValue, "Result is not equal to initial unsigned long long value")
//        } catch let error as NSError {
//            XCTFail("Failed with error: \(error.localizedDescription)")
//        }
//    }
//    
//    func testReadWriteFloatValue() {
//        let floatValue: CFloat = 2345.8434322
//        
//        let bitStream = RNBitStream()
//        bitStream.writeNumericValue(NSNumber(float: floatValue), ofType: .Float)
//        
//        let data = bitStream.data
//        XCTAssert(data.length == sizeof(floatValue.dynamicType), "Length of data is not equal to size of float value")
//        
//        do {
//            var result: NSNumber? = nil
//            try bitStream.readNumericValue(&result, ofType: .Float)
//            
//            XCTAssertNotNil(result, "Result is nil")
//            XCTAssert(result?.floatValue == floatValue, "Result is not equal to initial float value")
//        } catch let error as NSError {
//            XCTFail("Failed with error: \(error.localizedDescription)")
//        }
//    }
//    
//    func testReadWriteDoubleValue() {
//        let doubleValue: CDouble = 5423324.2342342344
//        
//        let bitStream = RNBitStream()
//        bitStream.writeNumericValue(NSNumber(double: doubleValue), ofType: .Double)
//        
//        let data = bitStream.data
//        XCTAssert(data.length == sizeof(doubleValue.dynamicType), "Length of data is not equal to size of double value")
//        
//        do {
//            var result: NSNumber? = nil
//            try bitStream.readNumericValue(&result, ofType: .Double)
//            
//            XCTAssertNotNil(result, "Result is nil")
//            XCTAssert(result?.doubleValue == doubleValue, "Result is not equal to initial double value")
//        } catch let error as NSError {
//            XCTFail("Failed with error: \(error.localizedDescription)")
//        }
//    }
//    
//    func testReadWriteStringValue() {
//        let stringValue = "😈 Some Unicode String 😈"
//        
//        let bitStream = RNBitStream()
//        bitStream.writeStringValue(stringValue)
//        
//        do {
//            var result: NSString? = nil
//            try bitStream.readStringValue(&result)
//            
//            XCTAssertNotNil(result, "Result is nil")
//            XCTAssert(result == stringValue, "Result is not equal to initial string value")
//        } catch let error as NSError {
//            XCTFail("Failed with error: \(error.localizedDescription)")
//        }
//    }
//    
//    func testReadWriteBytesArray() {
//        let bytes: [UInt8] = [0x12, 0x54, 0x44, 0x64]
//        let data = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
//        
//        let bitStream = RNBitStream()
//        bitStream.writeData(data)
//        
//        do {
//            var result: Data? = nil
//            try bitStream.readData(&result, withLength: bytes.count)
//            
//            XCTAssertNotNil(result, "Result is nil")
//            XCTAssert(result!.isEqual(data), "Result is not equal to initial data value")
//        } catch let error as NSError {
//            XCTFail("Failed with error: \(error.localizedDescription)")
//        }
//    }
//    
//    func testReadWriteMultipleValues() {
//        let doubleValue: CDouble = 5423324.2342342344
//        let stringValue = "😈 Some Unicode String 😈"
//        let shortValue: CShort = 6532
//        let bytes: [UInt8] = [0x12, 0x54, 0x44, 0x64]
//        let dataValue = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
//        let longValue: CLong = 23433577896
//        
//        let bitStream = RNBitStream()
//        bitStream.writeNumericValue(NSNumber(double: doubleValue), ofType: .Double)
//        bitStream.writeStringValue(stringValue)
//        bitStream.writeNumericValue(NSNumber(short: shortValue), ofType: .Short)
//        bitStream.writeData(dataValue)
//        bitStream.writeNumericValue(NSNumber(long: longValue), ofType: .Long)
//        
//        do {
//            var doubleResult: NSNumber? = nil
//            try bitStream.readNumericValue(&doubleResult, ofType: .Double)
//            XCTAssertNotNil(doubleResult, "Result is nil")
//            XCTAssert(doubleResult?.doubleValue == doubleValue, "Result is not equal to initial double value")
//            
//            var stringResult: NSString? = nil
//            try bitStream.readStringValue(&stringResult)
//            XCTAssertNotNil(stringResult, "Result is nil")
//            XCTAssert(stringResult == stringValue, "Result is not equal to initial string value")
//            
//            var shortResult: NSNumber? = nil
//            try bitStream.readNumericValue(&shortResult, ofType: .Short)
//            XCTAssertNotNil(shortResult, "Result is nil")
//            XCTAssert(shortResult?.int16Value == shortValue, "Result is not equal to initial short value")
//            
//            var dataResult: Data? = nil
//            try bitStream.readData(&dataResult, withLength: bytes.count)
//            XCTAssertNotNil(dataResult, "Result is nil")
//            XCTAssert(dataResult!.isEqual(dataValue), "Result is not equal to initial data value")
//            
//            var longResult: NSNumber? = nil
//            try bitStream.readNumericValue(&longResult, ofType: .Long)
//            XCTAssertNotNil(longResult, "Result is nil")
//            XCTAssert(longResult?.intValue == longValue, "Result is not equal to initial long value")
//        } catch let error as NSError {
//            XCTFail("Failed with error: \(error.localizedDescription)")
//        }
//    }
//    
//    func testReadWrongValue() {
//        let charValue: CChar = 12
//        
//        let bitStream = RNBitStream()
//        bitStream.writeNumericValue(NSNumber(char: charValue), ofType: .Char)
//        
//        var result: NSNumber? = nil
//        do {
//            try bitStream.readNumericValue(&result, ofType: .Double)
//            XCTFail("Reading double value was successfull but should fail")
//        } catch let error as NSError {
//            XCTAssertNil(result, "Result is not equal to nil")
//            XCTAssert(error.code == Int(RNBitStreamType.Double.rawValue), "Error code is not equal to raw value of RNBitStreamType.Double")
//        }
//    }
//    
//    func testModifyingReadPointer() {
//        XCTFail("Test of modifying read pointer is not implemented")
//    }
    
}
