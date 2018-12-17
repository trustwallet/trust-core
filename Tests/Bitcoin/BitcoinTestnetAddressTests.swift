// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore

class BitcoinTestnetAddressTests: XCTestCase {

    func testFromPrivateKeyLegacyAddress() {
        let privateKey = PrivateKey(wif: "5KagSjmhacRK8BKZn6RyJei4BZy5EVQcrAKdAmHib6TFKPPpjWK")!
        let publicKey = privateKey.publicKey(compressed: true)
        let address = Bitcoin(purpose: .bip44, network: .test).address(for: publicKey)

        XCTAssertEqual(address.description, "n3U23CQWzBAray99u6kJSipLh2VUDmt73h")
    }

    func testFromPrivateKeyCompatibleAddress() {
        let privateKey = PrivateKey(wif: "5KagSjmhacRK8BKZn6RyJei4BZy5EVQcrAKdAmHib6TFKPPpjWK")!
        let publicKey = privateKey.publicKey(compressed: true)
        let address = Bitcoin(purpose: .bip49, network: .test).address(for: publicKey)

        XCTAssertEqual(address.description, "2N9WgrehPoVfL5yYCDy6LjEA2N1yUoXY9pw")
    }

    func testFromPrivateKeyBech32Address() {
        let privateKey = PrivateKey(wif: "5KagSjmhacRK8BKZn6RyJei4BZy5EVQcrAKdAmHib6TFKPPpjWK")!
        let publicKey = privateKey.publicKey(compressed: true)
        let address = Bitcoin(purpose: .bip84, network: .test).address(for: publicKey)

        XCTAssertEqual(address.description, "tb1q7rz22qnw6tssa2ccnle8t9j3zn5zyap7kqva52")
    }

}
