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
        let pKey = PrivateKey(data: Data(hexString: "a8697743afbded16c4b57829394e557e11f39164e15e5ae704210ed09c3f9857")!)!
        var transaction: IconTransaction = IconTransaction(
            from: IconAddress(string: "hx1d2b61e4bd800abecce8062281b46a03026e08fb")!,
            to: IconAddress(string: "hx116f042497e5f34268b1b91e742680f84cf4e9f3")!,
            value: BigInt("5000000000000000000"),
            fee: BigInt("10000000000000000"),
            timestamp: "1538939713000000",
            nonce: 8367273)
        transaction.hash()
        transaction.sign(privateKey: pKey)

        XCTAssertEqual(transaction.tx_hash.hexString, "24c790715b220921e2ab7aa34173a24ead73f1b0f256093dc8e32755c27e061f")
        XCTAssertEqual(transaction.signature.hexString, "a0a97e345281cb4c1b359ff1f62eee095632947f8b86dccc9eafbec3df9b93764988d455d2c4e7f61e3f63e13d220dbc042ce75eda49a8ff633bee4b6ac5248e01")
    }
}
