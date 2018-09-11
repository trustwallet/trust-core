// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class TronTransactionTests: XCTestCase {
    func testTransactionHashing() {
        let rawData = TronTransaction.RawData(data: "This is a test TRON transaction".toData())
        let transactionToBeSigned = TronTransaction(rawData: rawData)

        XCTAssertEqual(
            "c2e987addda2e31b30e29e50346fcafd1844a6f652f8afb17560376a1aee56eb",
            transactionToBeSigned.hash().hexString
        )
    }
}
