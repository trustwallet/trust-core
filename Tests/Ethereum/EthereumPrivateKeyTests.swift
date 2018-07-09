// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class EthereumPrivateKeyTests: XCTestCase {
    func testCreateNew() {
        let privateKey = EthereumPrivateKey()

        XCTAssertEqual(privateKey.data.count, Ethereum.privateKeySize)
        XCTAssertTrue(EthereumPrivateKey.isValid(data: privateKey.data))
    }

    func testCreateFromString() {
        let privateKey = EthereumPrivateKey(string: "afeefca74d9a325cf1d6b6911d61a65c32afa8e02bd5e78e2e4ac2910bab45f5")

        XCTAssertNotNil(privateKey)
        XCTAssertEqual(privateKey!.data.hexString, "afeefca74d9a325cf1d6b6911d61a65c32afa8e02bd5e78e2e4ac2910bab45f5")
        XCTAssertEqual(privateKey!.description, "afeefca74d9a325cf1d6b6911d61a65c32afa8e02bd5e78e2e4ac2910bab45f5")
    }

    func testCreateFromInvalidString() {
        let privateKey = EthereumPrivateKey(string: "Z16EwEiKWKNnWGYwbNtrXjA8KKNntvxNKvepNqNeeLpfW7FSG1v")

        XCTAssertNil(privateKey)
    }

    func testIsValidString() {
        let valid = EthereumPrivateKey.isValid(string: "afeefca74d9a325cf1d6b6911d61a65c32afa8e02bd5e78e2e4ac2910bab45f5")

        XCTAssert(valid)
    }

    func testPublicKey() {
        let privateKey = EthereumPrivateKey(string: "afeefca74d9a325cf1d6b6911d61a65c32afa8e02bd5e78e2e4ac2910bab45f5")!
        let publicKey = privateKey.publicKey

        XCTAssertEqual(publicKey.data.hexString, "0499c6f51ad6f98c9c583f8e92bb7758ab2ca9a04110c0a1126ec43e5453d196c166b489a4b7c491e7688e6ebea3a71fc3a1a48d60f98d5ce84c93b65e423fde91")
    }
}
