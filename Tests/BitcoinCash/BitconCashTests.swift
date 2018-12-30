// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class BitcoinCashTests: XCTestCase {

    func testAddressInit() {
        let string = "qruxj7zq6yzpdx8dld0e9hfvt7u47zrw9gfr5hy0vh"
        let prefixString = [SLIP.HRP.bitcoincash.rawValue, "qruxj7zq6yzpdx8dld0e9hfvt7u47zrw9gfr5hy0vh"].joined(separator: ":")
        let expected = BitcoinCashAddress(string: prefixString)!

        XCTAssertEqual(expected, BitcoinCashAddress(string: prefixString))
        XCTAssertEqual(expected, BitcoinCashAddress(string: string))
        XCTAssertEqual(expected, BitcoinCashAddress(string: prefixString.capitalized))
    }

    func testLegacyToCashAddr() {
        let privateKey = PrivateKey(wif: "KxZX6Jv3to6RWnhsffTcLLryRnNyyc8Ng2G8P9LFkbCdzGDEhNy1")!
        let publicKey = privateKey.publicKey(compressed: true)
        let legacyAddress = BitcoinCash().legacyAddress(for: publicKey)
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
        let scriptPub2 = bc.buildScript(for: address2)!
        XCTAssertEqual(address2.toBitcoinAddress().description, "3Hv6oV8BYCoocW4eqZaEXsaR5tHhCxiMSk")
        XCTAssertEqual(scriptPub2.data.hexString, "a914b1fb7e043152fd1eed7bfaf66679ad3b6c9068f387")
        XCTAssertEqual(scriptPub2.data, bc.buildScript(for: address2.toBitcoinAddress())?.data)
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
        let bc = BitcoinCash()
        let xpubAddr2 = bc.derive(from: xpub, at: bc.derivationPath(at: 2))!
        let xpubAddr9 = bc.derive(from: xpub, at: bc.derivationPath(at: 9))!

        XCTAssertEqual(xpubAddr2.description, "qq4cm0hcc4trsj98v425f4ackdq7h92rsy6zzstrgy")
        XCTAssertEqual(xpubAddr9.description, "qqyqupaugd7mycyr87j899u02exc6t2tcg9frrqnve")
    }

    func testDeriveTestnetAddressFromXPub() {
        let xpub = "xpub6CEHLxCHR9sNtpcxtaTPLNxvnY9SQtbcFdov22riJ7jmhxmLFvXAoLbjHSzwXwNNuxC1jUP6tsHzFV9rhW9YKELfmR9pJaKFaM8C3zMPgjw"
        let bc = BitcoinCash(network: .test)
        let xpubAddr2 = bc.derive(from: xpub, at: bc.derivationPath(at: 2))!
        let xpubAddr9 = bc.derive(from: xpub, at: bc.derivationPath(at: 9))!

        XCTAssertEqual(xpubAddr2.description, "qq4cm0hcc4trsj98v425f4ackdq7h92rsy7sxhf50c")
        XCTAssertEqual(xpubAddr9.description, "qqyqupaugd7mycyr87j899u02exc6t2tcgpm8yzyt9")
    }

    func testSignTransaction() throws {
        // Transaction on Bitcoin Cash Mainnet
        // https://blockchair.com/bitcoin-cash/transaction/96ee20002b34e468f9d3c5ee54f6a8ddaa61c118889c4f35395c2cd93ba5bbb4
        let toAddress = BitcoinAddress(string: "1Bp9U1ogV3A14FMvKbRJms7ctyso4Z4Tcx")!
        let changeAddress = BitcoinAddress(string: "1FQc5LdgGHMHEN9nwkjmz6tWkxhPpxBvBU")!

        let unspentOutput = BitcoinTransactionOutput(value: 5151, script: BitcoinScript(data: Data(hexString: "76a914aff1e0789e5fe316b729577665aa0a04d5b0f8c788ac")!))

        let unspentOutpoint = BitcoinOutPoint(hash: Data(hexString: "e28c2b955293159898e34c6840d99bf4d390e2ee1c6f606939f18ee1e2000d05")!, index: 2)
        let utxo = BitcoinUnspentTransaction(output: unspentOutput, outpoint: unspentOutpoint)
        let utxoKey = PrivateKey(wif: "L1WFAgk5LxC5NLfuTeADvJ5nm3ooV3cKei5Yi9LJ8ENDfGMBZjdW")!

        let provider = BitcoinDefaultPrivateKeyProvider(keys: [utxoKey])

        let amount: Int64 = 600

        let unsignedTx = try BitcoinCash().build(to: toAddress, amount: amount, fee: 226, changeAddress: changeAddress, utxos: [utxo])

        let signer = BitcoinTransactionSigner(keyProvider: provider, transaction: unsignedTx, hashType: [.fork, .all])
        let signedTx = try signer.sign([utxo])

        var serialized = Data()
        signedTx.encode(into: &serialized)

        XCTAssertEqual(signedTx.transactionId, "96ee20002b34e468f9d3c5ee54f6a8ddaa61c118889c4f35395c2cd93ba5bbb4")
        // swiftlint:disable:next line_length
        XCTAssertEqual(serialized.hexString, "0100000001e28c2b955293159898e34c6840d99bf4d390e2ee1c6f606939f18ee1e2000d05020000006b483045022100b70d158b43cbcded60e6977e93f9a84966bc0cec6f2dfd1463d1223a90563f0d02207548d081069de570a494d0967ba388ff02641d91cadb060587ead95a98d4e3534121038eab72ec78e639d02758e7860cdec018b49498c307791f785aa3019622f4ea5bffffffff0258020000000000001976a914769bdff96a02f9135a1d19b749db6a78fe07dc9088ace5100000000000001976a9149e089b6889e032d46e3b915a3392edfd616fb1c488ac00000000")
    }
}
