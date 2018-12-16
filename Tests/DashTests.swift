// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class DashAddressTests: XCTestCase {
    func testAddress() {
        let privateKey = PrivateKey(wif: "XDoxFwfxsEZDd15uNyj8vt64c3GLxcFjTefnUz7gckvAJeYSFaRz")!
        let publicKey = privateKey.publicKey(compressed: true)
        let address = Dash().address(for: publicKey)

        XCTAssertEqual(address.description, "Xw7HTXGY3TFeA3ZsVuMRrYh96GtwWb4hQb")
    }
}
