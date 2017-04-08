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
        bitStream.write(value: boolValue)
        
        let data = bitStream.data
        XCTAssert(data.count == MemoryLayout<Bool>.size, "Length of data is not equal to size of bool value")
        
        var readValue: ObjCBool = false
        do {
            try bitStream.read(value: &readValue)
        } catch let error as NSError {
            XCTFail("Failed with error: \(error.localizedDescription)")
            return
        }
        
        XCTAssert(readValue.boolValue == boolValue, "Result is not equal to initial bool value")
    }
    
    func testReadWriteInt8Value() {
        let int8Value: Int8 = 12
        
        let bitStream = RNBitStream()
        bitStream.write(value: int8Value)
        
        let data = bitStream.data
        XCTAssert(data.count == MemoryLayout<Int8>.size, "Length of data is not equal to size of Int8 value")
        
        var readValue: Int8 = 0
        do {
            try bitStream.read(value: &readValue)
        } catch let error as NSError {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
        
        XCTAssert(readValue == int8Value, "Result is not equal to initial Int8 value")
    }
    
    func testReadWriteUInt8Value() {
        let uint8Value: UInt8 = 125
        
        let bitStream = RNBitStream()
        bitStream.write(value: uint8Value)
        
        let data = bitStream.data
        XCTAssert(data.count == MemoryLayout<UInt8>.size, "Length of data is not equal to size of UInt8 value")
        
        var readValue: UInt8 = 0
        do {
            try bitStream.read(value: &readValue)
        } catch let error as NSError {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
        
        XCTAssert(readValue == uint8Value, "Result is not equal to initial Int8 value")
    }
    
    func testReadWriteInt16Value() {
        let int16Value: Int16 = 6532
        
        let bitStream = RNBitStream()
        bitStream.write(value: int16Value)
        
        let data = bitStream.data
        XCTAssert(data.count == MemoryLayout<Int16>.size, "Length of data is not equal to size of Int16 value")
        
        var readValue: Int16 = 0
        do {
            try bitStream.read(value: &readValue)
        } catch let error as NSError {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }

        XCTAssert(readValue == int16Value, "Result is not equal to initial Int16 value")
    }
    
    func testReadWriteUInt16Value() {
        let uint16Value: UInt16 = 65000
        
        let bitStream = RNBitStream()
        bitStream.write(value: uint16Value)
        
        let data = bitStream.data
        XCTAssert(data.count == MemoryLayout<UInt16>.size, "Length of data is not equal to size of UInt16 value")
        
        var readValue: UInt16 = 0
        do {
            try bitStream.read(value: &readValue)
        } catch let error as NSError {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
        
        XCTAssert(readValue == uint16Value, "Result is not equal to initial UInt16 value")
    }
    
    func testReadWriteInt32Value() {
        let int32Value: Int32 = 328644322
        
        let bitStream = RNBitStream()
        bitStream.write(value: int32Value)
        
        let data = bitStream.data
        XCTAssert(data.count == MemoryLayout<Int32>.size, "Length of data is not equal to size of Int32 value")
        
        var readValue: Int32 = 0
        do {
            try bitStream.read(value: &readValue)
        } catch let error as NSError {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
        
        XCTAssert(readValue == int32Value, "Result is not equal to initial Int32 value")
    }
    
    func testReadWriteVarInt32Value() {
        let int32Value: Int32 = -328644322
        
        let bitStream = RNBitStream()
        bitStream.writeVar(value: int32Value)
        
        var readValue: Int32 = 0
        do {
            try bitStream.readVar(value: &readValue)
        } catch let error as NSError {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
        
        XCTAssert(readValue == int32Value, "Result is not equal to initial Int32 value")
    }
    
    func testReadWriteVarUInt32Value() {
        let int32Value: UInt32 = 3286443224
        
        let bitStream = RNBitStream()
        bitStream.writeVar(value: int32Value)
        
        var readValue: UInt32 = 0
        do {
            try bitStream.readVar(value: &readValue)
        } catch let error as NSError {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
        
        XCTAssert(readValue == int32Value, "Result is not equal to initial UInt32 value")
    }
    
    func testReadWriteUnsignedIntValue() {
//        let unsignedIntValue: CUnsignedInt = 4220843220
//        
//        let bitStream = RNBitStream()
//        bitStream.write(value: NSNumber(value: unsignedIntValue), type: .unsignedInt)
//        
//        let data = bitStream.data
//        XCTAssert(data.count == MemoryLayout<CUnsignedInt>.size, "Length of data is not equal to size of unsigned int value")
//        
//        do {
//            var result: NSNumber? = nil
//            try bitStream.read(value: &result, type: .unsignedInt)
//            
//            XCTAssertNotNil(result, "Result is nil")
//            XCTAssert(result?.uint32Value == unsignedIntValue, "Result is not equal to initial unsigned int value")
//        } catch let error as NSError {
//            XCTFail("Failed with error: \(error.localizedDescription)")
//        }
    }
    
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
    func testReadWriteFloatValue() {
        let floatValue: Float = 2345.8434322
        
        let bitStream = RNBitStream()
        bitStream.write(value: floatValue)
       
        let data = bitStream.data
        XCTAssert(data.count == MemoryLayout<Float>.size, "Length of data is not equal to size of Float value")
        
        var readValue: Float = 0
        do {
            try bitStream.read(value: &readValue)
        } catch {
            XCTFail("Failed with error: \(error.localizedDescription)")
            return
        }
        
        XCTAssert(floatValue == readValue)
    }

    func testReadWriteSwappedFloat() {
        let originalValue: Float = 738.974182
        
        let bytes: [UInt8] = [ 0x59, 0xbe, 0x38, 0x44 ]
        let data = Data(bytes: bytes)
        
        let bitStream = RNBitStream()
        bitStream.writeSwapped(value: originalValue)
        
        XCTAssert(data.elementsEqual(bitStream.data))
        
        var readValue: Float = 0
        do {
            try bitStream.readSwapped(value: &readValue)
        } catch {
            XCTFail("Failed with error: \(error.localizedDescription)")
            return
        }
        
        XCTAssert(originalValue == readValue)
    }
    
    func testReadWriteDoubleValue() {
        let doubleValue: Double = 5423324.2342342344
        
        let bitStream = RNBitStream()
        bitStream.write(value: doubleValue)
        
        let data = bitStream.data
        XCTAssert(data.count == MemoryLayout<Double>.size, "Length of data is not equal to size of Double value")
        
        var readValue: Double = 0
        do {
            try bitStream.read(value: &readValue)
        } catch {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
        
        XCTAssert(doubleValue == readValue)
    }
    
    func testReadWriteStringValue() {
        let stringValue = "😈 Some Unicode String 😈"
        
        let bitStream = RNBitStream()
        bitStream.write(value: stringValue)
        
        var readValue: NSString? = nil
        do {
            try bitStream.read(value: &readValue)
        } catch let error as NSError {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
        
        guard let result = readValue as? String else {
            XCTFail("Result is nil")
            return
        }

        XCTAssert(result == stringValue, "Result is not equal to initial string value")
    }
    
    func testReadWriteVarStringValue() {
        let stringValue = "😈 Some Unicode String 😈"
        
        let bitStream = RNBitStream()
        bitStream.writeVar(value: stringValue)
        
        var readValue: NSString? = nil
        do {
            try bitStream.readVar(value: &readValue)
        } catch let error as NSError {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
        
        guard let result = readValue as? String else {
            XCTFail("Result is nil")
            return
        }
        
        XCTAssert(result == stringValue, "Result is not equal to initial string value")
    }
    
    func testReadWriteBytesArray() {
        let bytes: [UInt8] = [0x12, 0x54, 0x44, 0x64]
        let data = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
        
        let bitStream = RNBitStream()
        bitStream.write(value: data)
        
        var readData: NSData? = nil
        do {
            try bitStream.read(value: &readData, length: bytes.count)
        } catch let error as NSError {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
        
        XCTAssert(readData as! Data == data)
    }
    
    func testReadWriteMultipleValues() {
        let doubleValue: Double = 5423324.2342342344
        let boolValue: Bool = false
        let stringValue = "😈 Some Unicode String 😈"
        let int16Value: Int16 = 6532
        let bytes: [UInt8] = [0x12, 0x54, 0x44, 0x64]
        let dataValue = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
        let int64Value: Int64 = 23433577896
        
        let bitStream = RNBitStream()
        bitStream.write(value: doubleValue)
        bitStream.write(value: boolValue)
        bitStream.write(value: stringValue)
        bitStream.write(value: int16Value)
        bitStream.write(value: dataValue)
        bitStream.write(value: int64Value)
        
        var readDouble: Double = 0
        var readBoolValue: ObjCBool = true
        var readString: NSString? = nil
        var readInt16: Int16 = 0
        var readData: NSData? = nil
        var readInt64: Int64 = 0
        
        do {
            try bitStream.read(value: &readDouble)
            try bitStream.read(value: &readBoolValue)
            try bitStream.read(value: &readString)
            try bitStream.read(value: &readInt16)
            try bitStream.read(value: &readData, length: bytes.count)
            try bitStream.read(value: &readInt64)
        } catch let error as NSError {
            XCTFail("Failed with error: \(error.localizedDescription)")
        }
        
        XCTAssert(readDouble == doubleValue)
        XCTAssert(readString as! String == stringValue)
        XCTAssert(readInt16 == int16Value)
        XCTAssert(readData as! Data == dataValue)
        XCTAssert(readInt64 == int64Value)
    }

    func testReadWrongValue() {
//        let charValue: CChar = 12
//        
//        let bitStream = RNBitStream()
//        bitStream.write(value: NSNumber(value: charValue), type: .char)
//        
//        var result: NSNumber? = nil
//        do {
//            try bitStream.read(value: &result, type: .double)
//            XCTFail("Reading double value was successfull but should fail")
//        } catch let error as NSError {
//            XCTAssertNil(result, "Result is not equal to nil")
//            XCTAssert(error.code == Int(RNBitStreamType.double.rawValue), "Error code is not equal to raw value of RNBitStreamType.Double")
//        }
    }
    
    func testModifyingReadPointer() {
        XCTFail("Test of modifying read pointer is not implemented")
    }
    
}
