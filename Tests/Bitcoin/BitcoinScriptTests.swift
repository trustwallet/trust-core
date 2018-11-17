// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
@testable import TrustCore

class BitcoinScriptTests: XCTestCase {
    func testRedeemScript() {
        let publicKey = PublicKey(data: Data(hexString: "042de45bea3dada528eee8a1e04142d3e04fad66119d971b6019b0e3c02266b79142158aa83469db1332a880a2d5f8ce0b3bba542b3e32df0740ccbfb01c275e42")!)!
        let address = publicKey.legacyBitcoinAddress(prefix: 0x05)
        XCTAssertEqual(address.description, "3LbBftXPhBmByAqgpZqx61ttiFfxjde2z7")

        let embeddedScript = BitcoinScript.buildPayToPublicKeyHash(address: address)
        let scriptPub1 = BitcoinScript.buildPayToScriptHash(script: embeddedScript)
        XCTAssertEqual(scriptPub1.data.hexString, "a914c470d22e69a2a967f2cec0cd5a5aebb955cdd39587")

        let address2 = BitcoinAddress(string: "38BW8nqpHSWpkf5sXrQd2xYwvnPJwP59ic")!
        let scriptPub2 = BitcoinScript.buildPayToScriptHash(address2.data.dropFirst())
        XCTAssertEqual(scriptPub2.data.hexString, "a9144733f37cf4db86fbc2efed2500b4f4e49f31202387")
    }

    func testLockScriptForP2PKHAddress() {
        let bitcoin = Bitcoin()
        let address = BitcoinAddress(string: "1Cu32FVupVCgHkMMRJdYJugxwo2Aprgk7H")!
        let scriptPub = bitcoin.buildScript(for: address)
        XCTAssertEqual(scriptPub?.data.hexString, "76a9148280b37df378db99f66f85c95a783a76ac7a6d5988ac")

        let address2 = BitcoinAddress(string: "16TZ8J6Q5iZKBWizWzFAYnrsaox5Z5aBRV")!
        let scriptPub2 = bitcoin.buildScript(for: address2)
        XCTAssertEqual(scriptPub2?.data.hexString, "76a9143bde42dbee7e4dbe6a21b2d50ce2f0167faa815988ac")
    }

    func testLockScriptForP2SHAddress() {
        let bitcoin = Bitcoin()
        let address = BitcoinAddress(string: "37rHiL4DN2wkt8pgCAUfYJRxhir98ZGN1y")!
        let scriptPub = bitcoin.buildScript(for: address)
        XCTAssertEqual(scriptPub?.data.hexString, "a9144391adbec172cad6a9fc3eebca36aeec6640abda87")

        let address2 = BitcoinAddress(string: "3HV63hgTNAgdiEp4FbJRPSVrjaV4ZoX4Bs")!
        let scriptPub2 = bitcoin.buildScript(for: address2)
        XCTAssertEqual(scriptPub2?.data.hexString, "a914ad40768af6419a20bdb94d83c06b6c8c94721dc087")
    }

    func testLockScriptForP2WPKHAddress() {
        let bitcoin = Bitcoin()
        let address = BitcoinBech32Address(string: "bc1q6hppaw7uld68amnnu5vpp5dd5u7k92c2vtdtkq")!
        let scriptPub = bitcoin.buildScript(for: address)
        XCTAssertEqual(scriptPub?.data.hexString, "0014d5c21ebbdcfb747eee73e51810d1ada73d62ab0a")

        let address2 = BitcoinBech32Address(string: "bc1qqw0jllft9pcr7r5uw0x08njkft0thd0g5yus0x")!
        let scriptPub2 = bitcoin.buildScript(for: address2)
        XCTAssertEqual(scriptPub2?.data.hexString, "0014039f2ffd2b28703f0e9c73ccf3ce564adebbb5e8")
    }

    func testLockScriptForInvalidAddress() {
        XCTAssertNil(Bitcoin().buildScript(for: EthereumAddress(string: "0x2457c289d6054910cc01d00d73deed368a907df7")!))
    }
}
