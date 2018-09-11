// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class TronTransactionTests: XCTestCase {
    let words = "ripple scissors kick mammal hire column oak again sun offer wealth tomorrow wagon turn fatal"
    let passphrase = "TREZOR"

    let rawString = "This is a test TRON transaction"
    let rawDataHashHexString = "c2e987addda2e31b30e29e50346fcafd1844a6f652f8afb17560376a1aee56eb"

    func testTransactionHashing() {
        let rawData = TronTransaction.RawData(data: rawString.toData())
        let transactionToBeSigned = TronTransaction(rawData: rawData)

        XCTAssertEqual(rawDataHashHexString, transactionToBeSigned.hash().hexString)
    }

    func testTransactionSigning() {
        let rawData = TronTransaction.RawData(data: rawString.toData())
        let hash = Data(hexString: rawDataHashHexString)!
        let privateKey = PrivateKey()
        let publicKey = privateKey.publicKey(compressed: true)

        var transactionToBeSigned = TronTransaction(rawData: rawData)

        XCTAssertFalse(transactionToBeSigned.hasSignature)

        let result = transactionToBeSigned.sign(privateKey: privateKey.data)

        XCTAssertEqual(result.count, 65)
        XCTAssertTrue(Crypto.verify(signature: result, message: hash, publicKey: publicKey.data))
        XCTAssertTrue(transactionToBeSigned.hasSignature)
    }
}
