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

    func testExtendedKeys() {
        let wallet = HDWallet(mnemonic: "ripple scissors kick mammal hire column oak again sun offer wealth tomorrow wagon turn fatal", passphrase: "TREZOR")

        let xprv = wallet.getExtendedPrivateKey(for: .bip44, coin: .bitcoincash, version: .xprv)
        let xpub = wallet.getExtendedPubKey(for: .bip44, coin: .bitcoincash, version: .xpub)

        XCTAssertEqual(xprv, "xprv9yEvwSfPanK5gLYVnYvNyF2CEWJx1RsktQtKDeT6jnCnqASBiPCvFYHFSApXv39bZbF6hRaha1kWQBVhN1xjo7NHuhAn5uUfzy79TBuGiHh")
        XCTAssertEqual(xpub, "xpub6CEHLxCHR9sNtpcxtaTPLNxvnY9SQtbcFdov22riJ7jmhxmLFvXAoLbjHSzwXwNNuxC1jUP6tsHzFV9rhW9YKELfmR9pJaKFaM8C3zMPgjw")
    }

    func testDeriveFromXPub() {
        let xpub = "xpub6CEHLxCHR9sNtpcxtaTPLNxvnY9SQtbcFdov22riJ7jmhxmLFvXAoLbjHSzwXwNNuxC1jUP6tsHzFV9rhW9YKELfmR9pJaKFaM8C3zMPgjw"
        let bc = BitcoinCash(purpose: .bip44)
        let xpubAddr2 = bc.derive(from: xpub, at: bc.derivationPath(at: 2))!
        let xpubAddr9 = bc.derive(from: xpub, at: bc.derivationPath(at: 9))!

        XCTAssertEqual(xpubAddr2.description, "bitcoincash:qq4cm0hcc4trsj98v425f4ackdq7h92rsy6zzstrgy")
        XCTAssertEqual(xpubAddr9.description, "bitcoincash:qqyqupaugd7mycyr87j899u02exc6t2tcg9frrqnve")
    }
}
