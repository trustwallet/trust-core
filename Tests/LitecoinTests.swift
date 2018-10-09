// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class LitecoinTests: XCTestCase {
    func testAddress() {
        let privateKey = PrivateKey()
        let publicKey = privateKey.publicKey(compressed: true)
        let address = Litecoin().compatibleAddress(for: publicKey)

        XCTAssert(address.description.hasPrefix("M"))
    }
}
