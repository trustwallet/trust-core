// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore

class TronAddressTests: XCTestCase {

    func testAddress() {
        let privateKey = PrivateKey(data: Data(hexString: "43B75088348B0E2F0B5FABC6F43CF5C084B0010FBFA2D86160A70E5AF7E17E56")!)!
        let address = privateKey.publicKey(for: .tron, compressed: true).address as! BitcoinAddress

        //XCTAssertEqual("TFhgyoHkWzhHcF9v1iWUsMxG1poAg8xxXb", address.description)
    }

    func testStringToAddress() {
        let address = TronAddress(string: "TFhgyoHkWzhHcF9v1iWUsMxG1poAg8xxXb")

        XCTAssertNotNil(address)
    }
}
