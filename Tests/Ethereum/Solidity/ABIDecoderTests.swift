// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import BigInt
import TrustCore
import XCTest

class ABIDecoderTests: XCTestCase {
    func testDecodeUInt() {
        let data = Data(hexString: "000000000000000000000000000000000000000000000000000000000000002a")!
        let decoder = ABIDecoder(data: data)

        XCTAssertEqual(decoder.decodeUInt(), 42)
    }

    func testDecodeInt() {
        let data = Data(hexString: "fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe")!
        let decoder = ABIDecoder(data: data)
        let value = decoder.decodeInt()

        XCTAssertEqual(value, BigInt(-2))
    }

    func testDecodeInt64() {
        let data = Data(hexString: "ffffffffffffffffffffffffffffffffffffffffffffffffffffb29c26f344fe")!
        let decoder = ABIDecoder(data: data)
        let value = decoder.decodeInt()

        XCTAssertEqual(value, BigInt("-85091238591234", radix: 10))
    }

    func testDecodeBool() {
        let data = Data(hexString: "00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000")!
        let decoder = ABIDecoder(data: data)

        XCTAssertEqual(decoder.decodeBool(), true)
        XCTAssertEqual(decoder.decodeBool(), false)
    }

    func testDecodeArray() throws {
        let data = Data(hexString:
            "0000000000000000000000000000000000000000000000000000000000000001" +
            "0000000000000000000000000000000000000000000000000000000000000002" +
            "0000000000000000000000000000000000000000000000000000000000000003"
        )!
        let decoder = ABIDecoder(data: data)
        let array = try decoder.decodeArray(type: .uint(bits: 256), count: 3)

        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array[0].nativeValue as? BigUInt, BigUInt(1))
        XCTAssertEqual(array[1].nativeValue as? BigUInt, BigUInt(2))
        XCTAssertEqual(array[2].nativeValue as? BigUInt, BigUInt(3))
    }

    func testDecodeDynamicArray() throws {
        let data = Data(hexString:
            "0000000000000000000000000000000000000000000000000000000000000003" +
            "0000000000000000000000000000000000000000000000000000000000000001" +
            "0000000000000000000000000000000000000000000000000000000000000002" +
            "0000000000000000000000000000000000000000000000000000000000000003"
        )!
        let decoder = ABIDecoder(data: data)
        let array = try decoder.decodeArray(type: .uint(bits: 256))

        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array[0].nativeValue as? BigUInt, BigUInt(1))
        XCTAssertEqual(array[1].nativeValue as? BigUInt, BigUInt(2))
        XCTAssertEqual(array[2].nativeValue as? BigUInt, BigUInt(3))
    }

    func testDecodeBytes() throws {
        let data = Data(hexString:
            "000000000000000000000000000000000000000000000000000000000000000b" +
            "68656c6c6f20776f726c64000000000000000000000000000000000000000000"
            )!
        let decoder = ABIDecoder(data: data)
        let decoded = decoder.decodeBytes()

        XCTAssertEqual(decoded, Data(hexString: "68656c6c6f20776f726c64"))
    }

    func testDecodeString() throws {
        let data = Data(hexString:
            "000000000000000000000000000000000000000000000000000000000000000b" +
            "68656c6c6f20776f726c64000000000000000000000000000000000000000000"
        )!
        let decoder = ABIDecoder(data: data)
        let string = try decoder.decodeString()

        XCTAssertEqual(string, "hello world")
    }

    func decodeTuple() throws {
        let data = Data(hexString:
            "0000000000000000000000000000000000000000000000000000000000000001" +
            "000000000000000000000000000000000000000000000000000000000000005c" +
            "0000000000000000000000000000000000000000000000000000000000000003"
        )!
        let decoder = ABIDecoder(data: data)
        let tuple = try decoder.decodeTuple(types: [.array(.uint(bits: 256), 2), .uint(bits: 256)])

        XCTAssertEqual(tuple.count, 2)

        guard let array = tuple[0].nativeValue as? [BigUInt] else {
            fatalError("Expected an array")
        }
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual(array[0], 1)
        XCTAssertEqual(array[1], 92)

        XCTAssertEqual(tuple[1].nativeValue as? BigUInt, 3)
    }

    func testDecodeFixed() throws {
        let data = Data(hexString: "0000000000000000000000000000000100000000000000000000000000000000")!
        let decoder = ABIDecoder(data: data)
        let value = try decoder.decode(type: .fixed(128, 128))

        guard case .fixed(_, _, let number) = value else {
            fatalError("Expected a `fixed` value")
        }
        XCTAssertEqual(number >> 128, 1)
    }

    func testDecodeAddress() {
        let data = Data(hexString: "0000000000000000000000005aaeb6053f3e94c9b9a09f33669435e7ef1beaed")!
        let decoder = ABIDecoder(data: data)

        XCTAssertEqual(decoder.decodeAddress(), EthereumAddress(string: "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed"))
    }

    func testFunctionWithDynamicArgumentsCase1() throws {
        let data = Data(hexString: "a5643bf2" +
            "0000000000000000000000000000000000000000000000000000000000000060" +
            "0000000000000000000000000000000000000000000000000000000000000001" +
            "00000000000000000000000000000000000000000000000000000000000000a0" +
            "0000000000000000000000000000000000000000000000000000000000000004" +
            "6461766500000000000000000000000000000000000000000000000000000000" +
            "0000000000000000000000000000000000000000000000000000000000000003" +
            "0000000000000000000000000000000000000000000000000000000000000001" +
            "0000000000000000000000000000000000000000000000000000000000000002" +
            "0000000000000000000000000000000000000000000000000000000000000003"
        )!
        let decoder = ABIDecoder(data: data)

        let function = Function(name: "sam", parameters: [
            .dynamicBytes,
            .bool,
            .dynamicArray(.uint(bits: 256)),
        ])

        guard case .function(_, let arguments) = try decoder.decode(type: .function(function)) else {
            fatalError("Expected a function")
        }

        XCTAssertEqual(arguments[0].nativeValue as? Data, Data(hexString: "64617665"))
        XCTAssertEqual(arguments[1].nativeValue as? Bool, true)
        XCTAssertEqual(arguments[2].nativeValue as? [BigUInt], [1, 2, 3])
    }
}
