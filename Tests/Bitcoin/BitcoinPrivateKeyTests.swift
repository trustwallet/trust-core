// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class BitcoinPrivateKeyTests: XCTestCase {
    func testCreateNew() {
        let privateKey = BitcoinPrivateKey()

        XCTAssertEqual(privateKey.data.count, Bitcoin.privateKeySize)
        XCTAssertTrue(BitcoinPrivateKey.isValid(data: privateKey.data))
    }

    func testCreateFromString() {
        let privateKey = BitcoinPrivateKey(string: "5K6EwEiKWKNnWGYwbNtrXjA8KKNntvxNKvepNqNeeLpfW7FSG1v")

        XCTAssertNotNil(privateKey)
        XCTAssertEqual(privateKey!.data.hexString, "a7ec27c206a68e33f53d6a35f284c748e0874ca2f0ea56eca6eb7668db0fe805")
        XCTAssertEqual(privateKey!.description, "5K6EwEiKWKNnWGYwbNtrXjA8KKNntvxNKvepNqNeeLpfW7FSG1v")
    }

    func testCreateFromInvalidString() {
        let privateKey = BitcoinPrivateKey(string: "Z16EwEiKWKNnWGYwbNtrXjA8KKNntvxNKvepNqNeeLpfW7FSG1v")

        XCTAssertNil(privateKey)
    }

    func testIsValidString() {
        let valid = BitcoinPrivateKey.isValid(string: "5K6EwEiKWKNnWGYwbNtrXjA8KKNntvxNKvepNqNeeLpfW7FSG1v")

        XCTAssert(valid)
    }

    func testPublicKey() {
        let privateKey = BitcoinPrivateKey(string: "5K6EwEiKWKNnWGYwbNtrXjA8KKNntvxNKvepNqNeeLpfW7FSG1v")!
        let publicKey = privateKey.publicKey

        XCTAssertEqual(publicKey.data.hexString, "045d21e7a118c479a007d45401bdbd06e3f9814ad5bbbbc5cec17f19029a060903ccfca71eff2101ad68238112e7585110e0f2c32d345225985356dc7cab8fdcc9")
    }
}
