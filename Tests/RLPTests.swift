// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import BigInt
import TrustCore
import XCTest

class RLPTests: XCTestCase {
    func testStrings() {
        XCTAssertEqual(RLP.encode("")!.hexString, "80")
        XCTAssertEqual(RLP.encode("dog")!.hexString, "83646f67")
    }

    func testIntegers() {
        XCTAssertEqual(RLP.encode(0)!.hexString, "80")
        XCTAssertEqual(RLP.encode(127)!.hexString, "7f")
        XCTAssertEqual(RLP.encode(128)!.hexString, "8180")
        XCTAssertEqual(RLP.encode(256)!.hexString, "820100")
        XCTAssertEqual(RLP.encode(1024)!.hexString, "820400")
        XCTAssertEqual(RLP.encode(0xffffff)!.hexString, "83ffffff")
        XCTAssertEqual(RLP.encode(0xffffffff as Int64)!.hexString, "84ffffffff")
        XCTAssertEqual(RLP.encode(0xffffffffffffff as Int64)!.hexString, "87ffffffffffffff")
    }

    func testBigInts() {
        XCTAssertEqual(RLP.encode(BigInt(0))!.hexString, "80")
        XCTAssertEqual(RLP.encode(BigInt(1))!.hexString, "01")
        XCTAssertEqual(RLP.encode(BigInt(127))!.hexString, "7f")
        XCTAssertEqual(RLP.encode(BigInt(128))!.hexString, "8180")
        XCTAssertEqual(RLP.encode(BigInt(256))!.hexString, "820100")
        XCTAssertEqual(RLP.encode(BigInt(1024))!.hexString, "820400")
        XCTAssertEqual(RLP.encode(BigInt(0xffffff))!.hexString, "83ffffff")
        XCTAssertEqual(RLP.encode(BigInt(0xffffffff as Int64))!.hexString, "84ffffffff")
        XCTAssertEqual(RLP.encode(BigInt(0xffffffffffffff as Int64))!.hexString, "87ffffffffffffff")
        XCTAssertEqual(
            RLP.encode(BigInt("102030405060708090a0b0c0d0e0f2", radix: 16)!)!.hexString,
            "8f102030405060708090a0b0c0d0e0f2"
        )
        XCTAssertEqual(
            RLP.encode(BigInt("0100020003000400050006000700080009000a000b000c000d000e01", radix: 16)!)!.hexString,
            "9c0100020003000400050006000700080009000a000b000c000d000e01"
        )
        XCTAssertEqual(
            RLP.encode(BigInt("010000000000000000000000000000000000000000000000000000000000000000", radix: 16)!)!.hexString,
            "a1010000000000000000000000000000000000000000000000000000000000000000"
        )
        XCTAssertNil(RLP.encode(BigInt("-1")!))
    }

    func testLists() {
        XCTAssertEqual(RLP.encode([])!.hexString, "c0")
        XCTAssertEqual(RLP.encode([1, 2, 3])!.hexString, "c3010203")
        XCTAssertEqual(RLP.encode(["cat", "dog"])!.hexString, "c88363617483646f67")
        XCTAssertEqual(RLP.encode([ [], [[]], [ [], [[]] ] ])!.hexString, "c7c0c1c0c3c0c1c0")
        XCTAssertEqual(RLP.encode([1, 0xffffff, [4, 5, 5], "abc"])!.hexString, "cd0183ffffffc304050583616263")
        let encoded = RLP.encode([Int](repeating: 0, count: 1024))!
        print(encoded.hexString)
        XCTAssert(encoded.hexString.hasPrefix("f90400"))
    }

    func testInvalid() {
        XCTAssertNil(RLP.encode(-1))
        XCTAssertNil(RLP.encode([0, -1]))
    }
}
