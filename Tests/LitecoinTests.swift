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
        let publicKey = privateKey.publicKey(for: .bitcoin, compressed: true) as! BitcoinPublicKey
        let address = publicKey.address(prefix: Litecoin.MainNet.payToScriptHashAddressPrefix)

        XCTAssert(address.description.hasPrefix("M"))
    }
}
