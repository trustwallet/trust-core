// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class TronAddressTests: XCTestCase {
    func testAddress() {
        let privateKey = PrivateKey()
        let publicKey = privateKey.publicKey(compressed: true)
        let address = Tron().address(for: publicKey)

        XCTAssert(address.description.hasPrefix("T"))
    }

    func testAddressWithRealData() {
        let privateKey = PrivateKey(data: "3d2eebd74075e98a55190b062ddd552c5f43f4b8379a1a1bcc8847a1c379a5e3".hexadecimal()!)
        let publicKeyUncompressed = privateKey!.publicKey(compressed: false)

        let address = Tron().address(for: publicKeyUncompressed)

        XCTAssertEqual("THyw5GEQrRFjBxjpiQrSkthzkN92BZY2sJ", address.description)

        /*
         reference:
         https://github.com/tronprotocol/Documentation/blob/master/TRX/Tron-overview.md
         https://github.com/tronprotocol/tron-demo/raw/master/TronConvertTool.zip
         */
    }
}
