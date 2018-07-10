// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import BigInt
import TrustCore
import XCTest

class ERC20EncoderTests: XCTestCase {
    let address = EthereumAddress(string: "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed")!

    func testEncodeTotalSupply() {
        XCTAssertEqual(ERC20Encoder.encodeTotalSupply().hexString, "18160ddd")
    }

    func testEncodeName() {
        XCTAssertEqual(ERC20Encoder.encodeName().hexString, "06fdde03")
    }

    func testEncodeSymbol() {
        XCTAssertEqual(ERC20Encoder.encodeSymbol().hexString, "95d89b41")
    }

    func testEncodeDecimals() {
        XCTAssertEqual(ERC20Encoder.encodeDecimals().hexString, "313ce567")
    }

    func testEncodeBalanceOf() {
        XCTAssertEqual(ERC20Encoder.encodeBalanceOf(address: address).hexString, "70a08231000000000000000000000000\(address.data.hexString)")
    }

    func testEncodeAllowance() {
        XCTAssertEqual(ERC20Encoder.encodeAllowance(owner: address, spender: address).hexString, "dd62ed3e000000000000000000000000\(address.data.hexString)000000000000000000000000\(address.data.hexString)")
    }

    func testEncodeTransfer() {
        XCTAssertEqual(ERC20Encoder.encodeTransfer(to: address, tokens: 1).hexString, "a9059cbb000000000000000000000000\(address.data.hexString)0000000000000000000000000000000000000000000000000000000000000001")
    }

    func testEncodeApprove() {
        XCTAssertEqual(ERC20Encoder.encodeApprove(spender: address, tokens: 1).hexString, "095ea7b3000000000000000000000000\(address.data.hexString)0000000000000000000000000000000000000000000000000000000000000001")
    }

    func testEncodeTransferFrom() {
        let encoded = ERC20Encoder.encodeTransfer(from: address, to: address, tokens: 1)
        XCTAssertEqual(encoded[0..<4].hexString, "23b872dd")
        XCTAssertEqual(encoded[16..<36].hexString, address.data.hexString)
        XCTAssertEqual(encoded[48..<68].hexString, address.data.hexString)
        XCTAssertEqual(BigUInt(encoded[68...]), BigUInt(1))
    }
}
