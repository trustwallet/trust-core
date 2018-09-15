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
        let publicKeyDataTrimed = publicKeyUncompressed.data.subdata(in: 1..<publicKeyUncompressed.data.count)

        XCTAssertEqual(65, publicKeyUncompressed.data.count)
        XCTAssertEqual("048d752b942beb0fa207d9bbd261728ad1f341a5e4d69d9b533cc4db897c47ea9b3f0f44faa4a2f1bad138045fcd560fcddaeeb601eba1ea50a3dd2eec75a54d39", publicKeyUncompressed.description)
        XCTAssertEqual("8d752b942beb0fa207d9bbd261728ad1f341a5e4d69d9b533cc4db897c47ea9b3f0f44faa4a2f1bad138045fcd560fcddaeeb601eba1ea50a3dd2eec75a54d39", publicKeyDataTrimed.hexString)

        let addressUncompressed = Tron().address(for: publicKeyUncompressed)
        let hashHexString = Crypto.hash(publicKeyDataTrimed).hexString

        XCTAssertEqual("64d5ea62079756dd55fc42ca57e42069ecdf9636ac3a50f31cf66e36dae5c951", hashHexString)

        let addressHexString = "41" + hashHexString.dropFirst(24)

        XCTAssertEqual("4157e42069ecdf9636ac3a50f31cf66e36dae5c951", addressHexString)

        let addressBase58 = Crypto.base58Encode(addressHexString.hexadecimal()!)

        XCTAssertEqual("THyw5GEQrRFjBxjpiQrSkthzkN92BZY2sJ", addressBase58)
        XCTAssertEqual("THyw5GEQrRFjBxjpiQrSkthzkN92BZY2sJ", addressUncompressed.description)

        let publicKeyCompressed = privateKey!.publicKey(compressed: true)
        let addressCompressed = Tron().address(for: publicKeyCompressed)

        XCTAssertEqual("038d752b942beb0fa207d9bbd261728ad1f341a5e4d69d9b533cc4db897c47ea9b", publicKeyCompressed.description)
        XCTAssertEqual("THyw5GEQrRFjBxjpiQrSkthzkN92BZY2sJ", addressCompressed.description)
        /*
         reference:
         https://github.com/tronprotocol/Documentation/blob/master/TRX/Tron-overview.md
         https://github.com/tronprotocol/tron-demo/raw/master/TronConvertTool.zip
         */
    }
}
