// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore
import BigInt

class IconTransactionTests: XCTestCase {
    //from: Wallet address of the sender - Format: ‘hx’ + 40 digit hex string
    //to: Wallet address of the recipient - Format: ‘hx’ + 40 digit hex string
    //value: Transfer amount (ICX) - Unit: 1/10^18 icx
    //fee: Fee for the transaction - Unit: 1/10^18 icx
    //timestamp: UNIX epoch time (Begin from 1970.1.1 00:00:00) - Unit: microseconds
    //nonce: Integer value increased by request to avoid ‘replay attack’

    func testHashTransaction() {
        var transaction: IconTransaction = IconTransaction(
            from: IconAddress(string: "hx1d2b61e4bd800abecce8062281b46a03026e08fb")!,
            to: IconAddress(string: "hx116f042497e5f34268b1b91e742680f84cf4e9f3")!,
            value: BigInt("1000000000000000000"),
            fee: BigInt("10000000000000000"),
            timestamp: "1538939206000000",
            nonce: 8367273)

        transaction.hash()
        XCTAssertEqual(transaction.tx_hash.hexString, "d373161998935913f7862e65ff9c69141cf72a0aeb73c3c13842938a81486c30")
    }

    func testSignTransaction() {
        let pKey = PrivateKey(data: Data(hexString: "a9d99d3a8d1e675e967b12e13ad5efe12d391325764bf9844a0ea48dfa663335")!)!
        var transaction: IconTransaction = IconTransaction(
            from: IconAddress(string: "hx9a4aa13be9f009a7ecce87ce0b81b8e922e97266")!,
            to: IconAddress(string: "hxfc26e36379afbfc9626aac5e405bd9445bb12523")!,
            value: BigInt("400000000000000000"),
            fee: BigInt("10000000000000000"),
            timestamp: "1538970344000000",
            nonce: 8367273)

        transaction.hash()
        transaction.sign(privateKey: pKey)
        XCTAssertEqual(transaction.tx_hash.hexString, "7fda8288fbcddcb28984f0579379ab05a0a7b985bdf6dd349db73d1a55c6bacf")
        XCTAssertEqual(transaction.signature.base64EncodedString(), "NzNzKhI3fVCWKpm5F7B8vZyJnEXun/nfXmVafoHEz0dnNoSNFoHxxjXWIJi2mMb9Ub/rxVGj3x5soYtP39QpzwA=")
    }

    func testVerifySignature() {
        let pKey0 = PrivateKey(data: Data(hexString: "a9d99d3a8d1e675e967b12e13ad5efe12d391325764bf9844a0ea48dfa663335")!)!
        let pKey1 = PrivateKey(data: Data(hexString: "a8697743afbded16c4b57829394e557e11f39164e15e5ae704210ed09c3f9857")!)!

        var transaction: IconTransaction = IconTransaction(
            from: pKey0.publicKey().iconAddress,
            to: IconAddress(string: "hxfc26e36379afbfc9626aac5e405bd9445bb12523")!,
            value: BigInt("400000000000000000"),
            fee: BigInt("10000000000000000"),
            timestamp: "1538970344000000",
            nonce: 8367273)

        transaction.hash()
        transaction.sign(privateKey: pKey0)
        XCTAssertTrue(transaction.verify(publicKey: pKey0.publicKey()))
        XCTAssertFalse(transaction.verify(publicKey: pKey1.publicKey()))
    }
}
