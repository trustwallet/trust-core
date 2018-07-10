// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import BigInt
import TrustCore
import XCTest

class ABIEncoderTests: XCTestCase {
    let encoder = ABIEncoder()

    override func setUp() {
        super.setUp()
        encoder.data = Data()
    }

    func testEncodeTrue() throws {
        try encoder.encode(true)
        XCTAssertEqual(encoder.data.hexString, "0000000000000000000000000000000000000000000000000000000000000001")
    }

    func testEncodeFalse() throws {
        try encoder.encode(false)
        XCTAssertEqual(encoder.data.hexString, "0000000000000000000000000000000000000000000000000000000000000000")
    }

    func testEncodeUInt() throws {
        try encoder.encode(69 as UInt)
        XCTAssertEqual(encoder.data.hexString, "0000000000000000000000000000000000000000000000000000000000000045")
    }

    func testEncodeNegativeInt() throws {
        try encoder.encode(-1)
        XCTAssertEqual(encoder.data.hexString, "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
    }

    func testEncodeBigUInt() throws {
        try encoder.encode(BigUInt("1234567890123456789012345678901234567890", radix: 16)!)
        XCTAssertEqual(encoder.data.hexString, "0000000000000000000000001234567890123456789012345678901234567890")
    }

    func testEncodeNegativeBigInt() throws {
        try encoder.encode(BigInt("-1", radix: 10)!)
        XCTAssertEqual(encoder.data.hexString, "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
    }

    func testOverflow() {
        XCTAssertThrowsError(try encoder.encode(BigInt("F123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0", radix: 16)!)) { error in
            if case ABIError.integerOverflow = error {
                // All good
            } else {
                XCTFail("Expected ABIEncodingError.overflow")
            }
        }
    }

    func testSignature() throws {
        try encoder.encode(signature: "baz(uint32,bool)")
        try encoder.encode(69)
        try encoder.encode(true)
        XCTAssertEqual(encoder.data.hexString, "cdcd77c000000000000000000000000000000000000000000000000000000000000000450000000000000000000000000000000000000000000000000000000000000001")
    }

    func testFunctionWithDynamicArgumentsCase1() throws {
        let function = Function(name: "sam", parameters: [
            .dynamicBytes,
            .bool,
            .dynamicArray(.uint(bits: 256)),
        ])
        try encoder.encode(function: function, arguments: ["dave", true, [1, 2, 3]])

        XCTAssertEqual(encoder.data.count, 32 * 9 + 4)
        XCTAssertEqual(encoder.data[  0..<4  ].hexString, "a5643bf2")
        XCTAssertEqual(encoder.data[  4..<36 ].hexString, "0000000000000000000000000000000000000000000000000000000000000060")
        XCTAssertEqual(encoder.data[ 36..<68 ].hexString, "0000000000000000000000000000000000000000000000000000000000000001")
        XCTAssertEqual(encoder.data[ 68..<100].hexString, "00000000000000000000000000000000000000000000000000000000000000a0")
        XCTAssertEqual(encoder.data[100..<132].hexString, "0000000000000000000000000000000000000000000000000000000000000004")
        XCTAssertEqual(encoder.data[132..<164].hexString, "6461766500000000000000000000000000000000000000000000000000000000")
        XCTAssertEqual(encoder.data[164..<196].hexString, "0000000000000000000000000000000000000000000000000000000000000003")
        XCTAssertEqual(encoder.data[196..<228].hexString, "0000000000000000000000000000000000000000000000000000000000000001")
        XCTAssertEqual(encoder.data[228..<260].hexString, "0000000000000000000000000000000000000000000000000000000000000002")
        XCTAssertEqual(encoder.data[260..<292].hexString, "0000000000000000000000000000000000000000000000000000000000000003")
    }

    func testFunctionWithDynamicArgumentsCase2() throws {
        let function = Function(name: "f", parameters: [
            .uint(bits: 256),
            .dynamicArray(.uint(bits: 32)),
            .bytes(10),
            .dynamicBytes,
        ])
        try encoder.encode(function: function, arguments: [0x123, [0x456, 0x789], "1234567890".data(using: .utf8)!, "Hello, world!"])
        XCTAssertEqual(encoder.data.count, 32 * 9 + 4)
        XCTAssertEqual(encoder.data[  0..<4  ].hexString, "8be65246")
        XCTAssertEqual(encoder.data[  4..<36 ].hexString, "0000000000000000000000000000000000000000000000000000000000000123")
        XCTAssertEqual(encoder.data[ 36..<68 ].hexString, "0000000000000000000000000000000000000000000000000000000000000080")
        XCTAssertEqual(encoder.data[ 68..<100].hexString, "3132333435363738393000000000000000000000000000000000000000000000")
        XCTAssertEqual(encoder.data[100..<132].hexString, "00000000000000000000000000000000000000000000000000000000000000e0")
        XCTAssertEqual(encoder.data[132..<164].hexString, "0000000000000000000000000000000000000000000000000000000000000002")
        XCTAssertEqual(encoder.data[164..<196].hexString, "0000000000000000000000000000000000000000000000000000000000000456")
        XCTAssertEqual(encoder.data[196..<228].hexString, "0000000000000000000000000000000000000000000000000000000000000789")
        XCTAssertEqual(encoder.data[228..<260].hexString, "000000000000000000000000000000000000000000000000000000000000000d")
        XCTAssertEqual(encoder.data[260..<292].hexString, "48656c6c6f2c20776f726c642100000000000000000000000000000000000000")
    }
}
