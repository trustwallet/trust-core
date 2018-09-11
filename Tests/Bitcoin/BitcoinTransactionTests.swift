// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class BitcoinTransactionTests: XCTestCase {
    func testEncode() {
        let inputs = [
            BitcoinTransactionInput(
                previousOutput: BitcoinOutPoint(hash: Data(hexString: "5897de6bd6027a475eadd57019d4e6872c396d0716c4875a5f1a6fcfdf385c1f")!, index: 0),
                script: BitcoinScript(bytes: []),
                sequence: 4294967295),
            BitcoinTransactionInput(
                previousOutput: BitcoinOutPoint(hash: Data(hexString: "bf829c6bcf84579331337659d31f89dfd138f7f7785802d5501c92333145ca7c")!, index: 18),
                script: BitcoinScript(bytes: []),
                sequence: 4294967295),
            BitcoinTransactionInput(
                previousOutput: BitcoinOutPoint(hash: Data(hexString: "22a6f904655d53ae2ff70e701a0bbd90aa3975c0f40bfc6cc996a9049e31cdfc")!, index: 1),
                script: BitcoinScript(bytes: []),
                sequence: 4294967295),
        ]
        let outputs = [
            BitcoinTransactionOutput(
                value: 18000000 as Int64,
                script: BitcoinScript(bytes: [0x76, 0xa9, 0x14, 0x1f, 0xc1, 0x1f, 0x39, 0xbe, 0x17, 0x29, 0xbf, 0x97, 0x3a, 0x7a, 0xb6, 0xa6, 0x15, 0xca, 0x47, 0x29, 0xd6, 0x45, 0x74, 0x88, 0xac])),
            BitcoinTransactionOutput(
                value: 400000000 as Int64,
                script: BitcoinScript(bytes: [0x76, 0xa9, 0x14, 0xf2, 0xd4, 0xdb, 0x28, 0xca, 0xd6, 0x50, 0x22, 0x26, 0xee, 0x48, 0x4a, 0xe2, 0x45, 0x05, 0xc2, 0x88, 0x5c, 0xb1, 0x2d, 0x88, 0xac])),
        ]
        let tx = BitcoinTransaction(version: 2, inputs: inputs, outputs: outputs, lockTime: 0)
        var encoded = Data()
        tx.encode(into: &encoded)

        // swiftlint:disable:next line_length
        XCTAssertEqual(encoded.hexString, "02000000035897de6bd6027a475eadd57019d4e6872c396d0716c4875a5f1a6fcfdf385c1f0000000000ffffffffbf829c6bcf84579331337659d31f89dfd138f7f7785802d5501c92333145ca7c1200000000ffffffff22a6f904655d53ae2ff70e701a0bbd90aa3975c0f40bfc6cc996a9049e31cdfc0100000000ffffffff0280a81201000000001976a9141fc11f39be1729bf973a7ab6a615ca4729d6457488ac0084d717000000001976a914f2d4db28cad6502226ee484ae24505c2885cb12d88ac00000000")
    }

    func testDecodeScriptHash() {
        let script = BitcoinScript(data: Data(hexString: "a914cf5007e19af3641199f21f3fa54dff2fa262747187")!)
        let hash = script.matchPayToScriptHash()!
        XCTAssertEqual(Crypto.base58Encode(hash), "3LbBftXPhBmByAqgpZqx61ttiFfxjde2z7")
    }
}
