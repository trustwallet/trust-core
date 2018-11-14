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
    func testSignTransaction() {
        let privateKey = PrivateKey(data: Data(hexString: "a9d99d3a8d1e675e967b12e13ad5efe12d391325764bf9844a0ea48dfa663335")!)!
        var transaction: IconTransaction = IconTransaction(
            from: IconAddress(string: "hx9a4aa13be9f009a7ecce87ce0b81b8e922e97266")!,
            to: IconAddress(string: "hxfc26e36379afbfc9626aac5e405bd9445bb12523")!,
            value: BigInt("400000000000000000"),
            stepLimit: BigInt("100000"),
            timestamp: "1538970344000000",
            nonce: 8367273)

        transaction.sign(hashSigner: { data in
            return Crypto.sign(hash: data, privateKey: privateKey.data)
        })

        XCTAssertEqual(transaction.tx_hash.hexString, "f7ae911f8ec18aca5633a65ed42a980eb425935ce672f4b252a28c778e9d43e5")
        XCTAssertEqual(transaction.signature.base64EncodedString(), "65pmfobD1vnV4aoNEirfBdWq6SveDgWBBlaDF/dAaJY85jUsEtQMq8UG4Xv+U6h0zx3EBsFiXgi1o3CxHRHv/gA=")
    }
}
