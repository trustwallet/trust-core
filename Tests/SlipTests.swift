// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore

class SlipTests: XCTestCase {

    func testCoinType() {
        XCTAssertEqual(SLIP.CoinType.bitcoin.rawValue, 0)
        XCTAssertEqual(SLIP.CoinType.litecoin.rawValue, 2)
        XCTAssertEqual(SLIP.CoinType.tron.rawValue, 195)
        XCTAssertEqual(SLIP.CoinType.ethereum.rawValue, 60)
        XCTAssertEqual(SLIP.CoinType.thunderToken.rawValue, 1001)
        XCTAssertEqual(SLIP.CoinType.wanchain.rawValue, 5718350)
        XCTAssertEqual(SLIP.CoinType.callisto.rawValue, 820)
        XCTAssertEqual(SLIP.CoinType.ethereumClassic.rawValue, 61)
        XCTAssertEqual(SLIP.CoinType.go.rawValue, 6060)
        XCTAssertEqual(SLIP.CoinType.poa.rawValue, 178)
        XCTAssertEqual(SLIP.CoinType.vechain.rawValue, 818)
        XCTAssertEqual(SLIP.CoinType.icon.rawValue, 888888) //Temporary
    }
}
