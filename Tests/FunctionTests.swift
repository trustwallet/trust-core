// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class FunctionTests: XCTestCase {
    func testDesription() {
        let function = Function(name: "f", parameters: [
            .uint(bits: 256),
            .dynamicArray(.uint(bits: 32)),
            .bytes(10),
            .dynamicBytes,
        ])
        XCTAssertEqual(function.description, "f(uint256,uint32[],bytes10,bytes)")
    }

    func testInvalidNumberOfArguments() {
        let function = Function(name: "f", parameters: [
            .uint(bits: 256),
            .dynamicArray(.uint(bits: 32)),
            .bytes(10),
            .dynamicBytes,
        ])
        XCTAssertThrowsError(try function.castArguments([1])) { error in
            switch error {
            case ABIError.invalidNumberOfArguments:
                break
            default:
                XCTFail("Expected `invalidNumberOfArguments`, got `\(error)`")
            }
        }
    }

    func testInvalidType() {
        let function = Function(name: "f", parameters: [
            .dynamicArray(.uint(bits: 32)),
        ])
        XCTAssertThrowsError(try function.castArguments([1])) { error in
            switch error {
            case ABIError.invalidArgumentType:
                break
            default:
                XCTFail("Expected `invalidArgumentType`, got `\(error)`")
            }
        }
    }
}
