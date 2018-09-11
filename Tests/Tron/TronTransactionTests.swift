// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class TronTransactionTests: XCTestCase {
    func testTransactionSigning() {
        let rawString = "This is a test TRON transaction"
        let rawData = TronTransaction.RawData(data: rawString.toData())
        var transactionToBeSigned = TronTransaction(rawData: rawData)

        let hashHexString = transactionToBeSigned.hash().hexString
        let hashData = Data(hexString: hashHexString)!

        XCTAssertEqual(64, hashHexString.count)

        let privateKey = PrivateKey()
        let publicKey = privateKey.publicKey(compressed: true)

        XCTAssertFalse(transactionToBeSigned.hasSignature)

        let result = transactionToBeSigned.sign(privateKey: privateKey.data)

        XCTAssertEqual(result.count, 65)
        XCTAssertTrue(Crypto.verify(signature: result, message: hashData, publicKey: publicKey.data))
        XCTAssertTrue(transactionToBeSigned.hasSignature)
    }
}
