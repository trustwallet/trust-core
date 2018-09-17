// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class TronTransactionTests: XCTestCase {
    func testTransactionSigning() {
        let privateKey = PrivateKey(data: Data(hexString: "70815e46680f0c131844b34c33ef0385b5c459820a8d091f97b646db2396e37e")!)!
        let publicKey = privateKey.publicKey()
        var transactionToBeSigned = TronTransactionBuilder()
            .build(
                from: "TGQaQoCM7LprSH4TE4FemmZhEQMZMKvAGH",
                to: "TKbhYo6a8nDjfVryNwh4oG5GA7kXfVSyqf",
                amount: 11000,
                note: "Test"
            )

        let hashHexString = transactionToBeSigned.hash().hexString
        let result = transactionToBeSigned.sign(privateKey: privateKey.data)

        XCTAssertEqual("TGQaQoCM7LprSH4TE4FemmZhEQMZMKvAGH", Tron().address(for: publicKey).description)
        XCTAssertTrue(Crypto.verify(signature: result, message: Data(hexString: hashHexString)!, publicKey: publicKey.data))
        XCTAssertTrue(transactionToBeSigned.hasSignature)
        XCTAssertEqual("a943346e80b45b4aebca8bd398b6787d98451819d1f72a6c5357f2e013cb678d3f116ca0f0cb49e5c3d7f7dfbab28445f1de563a528b6949a94695c6f8bdae5200", result.hexString)
    }
}
