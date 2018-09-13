// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore

class PurposeTests: XCTestCase {

    func testPurpose() {
        XCTAssertEqual(.bip49, Bitcoin().coinPurpose)
        XCTAssertEqual(.bip49, Litecoin().coinPurpose)
        XCTAssertEqual(.bip49, Dash().coinPurpose)
        XCTAssertEqual(.bip44, Ethereum().coinPurpose)
        XCTAssertEqual(.bip44, Wanchain().coinPurpose)
        XCTAssertEqual(.bip44, Vechain().coinPurpose)
        XCTAssertEqual(.bip44, Go().coinPurpose)
    }
}
