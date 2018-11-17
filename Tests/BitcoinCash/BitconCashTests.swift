// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class BitcoinCashTests: XCTestCase {
    func testLegacyToCashAddr() {
        let privateKey = PrivateKey(wif: "KxZX6Jv3to6RWnhsffTcLLryRnNyyc8Ng2G8P9LFkbCdzGDEhNy1")!
        let publicKey = privateKey.publicKey(compressed: true)
        let legacyAddress = Bitcoin().legacyAddress(for: publicKey)
        XCTAssertEqual(legacyAddress.description, "1PeUvjuxyf31aJKX6kCXuaqxhmG78ZUdL1")

        let cashAddress = publicKey.cashAddress()
        XCTAssertEqual(cashAddress, BitcoinCashAddress(string: "bitcoincash:qruxj7zq6yzpdx8dld0e9hfvt7u47zrw9gfr5hy0vh")!)

        // P2PWKH-P2SH :)
        let compatibleAddress = publicKey.compatibleBitcoinAddress(prefix: Bitcoin().p2shPrefix)
        XCTAssertEqual(compatibleAddress, BitcoinAddress(string: "3QDXdmS93CokXi2Pmk52jM96icVEs8Mgpg")!)

        let redeemScript = BitcoinScript.buildPayToWitnessPubkeyHash(publicKey.bitcoinKeyHash)
        let cashAddress2 = publicKey.cashAddress(redeemScript: redeemScript)

        XCTAssertEqual(cashAddress2, BitcoinCashAddress(string: "bitcoincash:prm3srpqu4kmx00370m4wt5qr3cp7sekmcksezufmd")!)
    }

    func testLockScript() {
        let bc = BitcoinCash()
        let address = BitcoinCashAddress(string: "bitcoincash:qpk05r5kcd8uuzwqunn8rlx5xvuvzjqju5rch3tc0u")!
        let legacyAddress = BitcoinAddress(string: "1AwDXywmyhASpCCFWkqhySgZf8KiswFoGh")!
        XCTAssertEqual(address.toBitcoinAddress(), legacyAddress)

        let scriptPub = bc.buildScript(for: address)!
        XCTAssertEqual(scriptPub.data, bc.buildScript(for: legacyAddress)?.data)
        XCTAssertEqual(scriptPub.data.hexString, "76a9146cfa0e96c34fce09c0e4e671fcd43338c14812e588ac")

        let address2 = BitcoinCashAddress(string: "bitcoincash:pzclklsyx9f068hd00a0vene45akeyrg7vv0053uqf")!
        XCTAssertEqual(address2.toBitcoinAddress().description, "3Hv6oV8BYCoocW4eqZaEXsaR5tHhCxiMSk")
        XCTAssertNil(bc.buildScript(for: address2))
        XCTAssertNil(bc.buildScript(for: address2.toBitcoinAddress()))
    }
}
