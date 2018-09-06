// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore

class SlipTests: XCTestCase {

    func testCoinType() {
        XCTAssertEqual(Slip.bitcoin.rawValue, 0)
        XCTAssertEqual(Slip.litecoin.rawValue, 2)
        XCTAssertEqual(Slip.tron.rawValue, 195)
        XCTAssertEqual(Slip.ethereum.rawValue, 60)
        XCTAssertEqual(Slip.wanchain.rawValue, 5718350)
        XCTAssertEqual(Slip.callisto.rawValue, 820)
        XCTAssertEqual(Slip.ethereumClassic.rawValue, 61)
        XCTAssertEqual(Slip.go.rawValue, 6060)
        XCTAssertEqual(Slip.vechain.rawValue, 818)
    }
}
