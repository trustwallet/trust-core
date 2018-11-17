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
}
