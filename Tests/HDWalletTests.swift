// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrezorCrypto
import TrustCore
import XCTest

class HDWalletTests: XCTestCase {
    let words = "ripple scissors kick mammal hire column oak again sun offer wealth tomorrow wagon turn fatal"
    let passphrase = "TREZOR"

    func testSeed() {
        let wallet = HDWallet(mnemonic: words, passphrase: passphrase)
        XCTAssertEqual(wallet.seed.hexString, "7ae6f661157bda6492f6162701e570097fc726b6235011ea5ad09bf04986731ed4d92bc43cbdee047b60ea0dd1b1fa4274377c9bf5bd14ab1982c272d8076f29")
    }

    func testSeedNoPassword() {
        let wallet = HDWallet(mnemonic: words, passphrase: "")
        XCTAssertEqual(wallet.seed.hexString, "354c22aedb9a37407adc61f657a6f00d10ed125efa360215f36c6919abd94d6dbc193a5f9c495e21ee74118661e327e84a5f5f11fa373ec33b80897d4697557d")
    }

    func testDerive() {
        let wallet = HDWallet(mnemonic: words, passphrase: passphrase)
        let key0 = wallet.getKey(at: Ethereum().derivationPath(at: 0))
        let key1 = wallet.getKey(at: Ethereum().derivationPath(at: 1))
        XCTAssertEqual(key0.publicKey().ethereumAddress.description, "0x27Ef5cDBe01777D62438AfFeb695e33fC2335979")
        XCTAssertEqual(key1.publicKey().ethereumAddress.description, "0x98f5438cDE3F0Ff6E11aE47236e93481899d1C47")
    }

    func testDeriveBitcoin() {
        let blockchain = Bitcoin()
        let wallet = HDWallet(mnemonic: words, passphrase: passphrase)
        let key = wallet.getKey(at: blockchain.derivationPath(at: 0))
        let address = blockchain.address(for: key.publicKey())
        XCTAssertEqual("3FJjnZNXC6FWQ2UJAaKL3Vme2EJavfgnXe", address.description)
        XCTAssertEqual(key.publicKey().compressed.description, key.publicKey(compressed: true).description)
    }

    func testDeriveTron() {
        let blockchain = Tron()
        let wallet = HDWallet(mnemonic: words, passphrase: passphrase)
        let key = wallet.getKey(at: blockchain.derivationPath(at: 0))
        let address = blockchain.address(for: key.publicKey())
        XCTAssertEqual("THJrqfbBhoB1vX97da6S6nXWkafCxpyCNB", address.description)
    }
    
    func testDeriveIcon() {
        let blockchain = Icon()
        let wallet = HDWallet(mnemonic: words, passphrase: passphrase)
        let key0 = wallet.getKey(at: blockchain.derivationPath(at: 0))
        let key1 = wallet.getKey(at: blockchain.derivationPath(at: 1))
        let address0 = blockchain.address(for: key0.publicKey())
        let address1 = blockchain.address(for: key1.publicKey())
        XCTAssertEqual("hx70648a3fc552b8a334e8edfdd16c938cc3185f93", address0.description)
        XCTAssertEqual("hx44d92f89fa618778e4b595975e3de74e8e19aa10", address1.description)
    }

    func testSignHash() {
        let wallet = HDWallet(mnemonic: words, passphrase: passphrase)
        let key = wallet.getKey(at: Ethereum().derivationPath(at: 0))
        let hash = Data(hexString: "3F891FDA3704F0368DAB65FA81EBE616F4AA2A0854995DA4DC0B59D2CADBD64F")!
        let result = Crypto.sign(hash: hash, privateKey: key.data)

        let publicKey = key.publicKey()
        XCTAssertEqual(result.count, 65)
        XCTAssertTrue(Crypto.verify(signature: result, message: hash, publicKey: publicKey.data))
    }
}
