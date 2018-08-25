// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class CoinTests: XCTestCase {
    func testCreateWithIDOnly() {
        XCTAssertEqual(Coin(coinType: 0).blockchain, .bitcoin)
        XCTAssertEqual(Coin(coinType: 60).blockchain, .ethereum)
        XCTAssertEqual(Coin(coinType: 61).blockchain, .ethereumClassic)
        XCTAssertEqual(Coin(coinType: 178).blockchain, .poa)
        XCTAssertEqual(Coin(coinType: 818).blockchain, .vechain)
        XCTAssertEqual(Coin(coinType: 5718350).blockchain, .wanchain)
    }
}
