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
        XCTAssertEqual("bc1qumwjg8danv2vm29lp5swdux4r60ezptzz7ce85", address.description)
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
        XCTAssertEqual("hx78c6f744c68d48793cd64716189c181c66907b24", address0.description)
        XCTAssertEqual("hx92373c16531761b31a7124c94718da43db8c9d89", address1.description)
    }

    func testDeriveEOS() {
        let blockchain = EOS()
        let wallet = HDWallet(mnemonic: words, passphrase: passphrase)
        let key = wallet.getKey(at: blockchain.derivationPath(at: 0))
        let address = blockchain.address(for: key.publicKey().compressed)
        XCTAssertEqual("EOS5LhLzbYV9jL94MYSFFnuKUX4fSB9xRp2zmXBxZ9AjmbAwZKxoq", address.description)
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

    func testExtendedKeys() {
        let wallet = HDWallet(mnemonic: "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about", passphrase: "")

        let xprv = wallet.getExtendedPrivateKey(for: .bip44, version: .xprv)
        let xpub = wallet.getExtendedPubKey(for: .bip44, version: .xpub)

        XCTAssertEqual(xprv, "xprv9xpXFhFpqdQK3TmytPBqXtGSwS3DLjojFhTGht8gwAAii8py5X6pxeBnQ6ehJiyJ6nDjWGJfZ95WxByFXVkDxHXrqu53WCRGypk2ttuqncb")
        XCTAssertEqual(xpub, "xpub6BosfCnifzxcFwrSzQiqu2DBVTshkCXacvNsWGYJVVhhawA7d4R5WSWGFNbi8Aw6ZRc1brxMyWMzG3DSSSSoekkudhUd9yLb6qx39T9nMdj")

        let yprv = wallet.getExtendedPrivateKey(for: .bip49, version: .yprv)
        let ypub = wallet.getExtendedPubKey(for: .bip49, version: .ypub)
        XCTAssertEqual(yprv, "yprvAHwhK6RbpuS3dgCYHM5jc2ZvEKd7Bi61u9FVhYMpgMSuZS613T1xxQeKTffhrHY79hZ5PsskBjcc6C2V7DrnsMsNaGDaWev3GLRQRgV7hxF")
        XCTAssertEqual(ypub, "ypub6Ww3ibxVfGzLrAH1PNcjyAWenMTbbAosGNB6VvmSEgytSER9azLDWCxoJwW7Ke7icmizBMXrzBx9979FfaHxHcrArf3zbeJJJUZPf663zsP")

        let zprv = wallet.getExtendedPrivateKey(for: .bip84, version: .zprv)
        let zpub = wallet.getExtendedPubKey(for: .bip84, version: .zpub)
        XCTAssertEqual(zprv, "zprvAdG4iTXWBoARxkkzNpNh8r6Qag3irQB8PzEMkAFeTRXxHpbF9z4QgEvBRmfvqWvGp42t42nvgGpNgYSJA9iefm1yYNZKEm7z6qUWCroSQnE")
        XCTAssertEqual(zpub, "zpub6rFR7y4Q2AijBEqTUquhVz398htDFrtymD9xYYfG1m4wAcvPhXNfE3EfH1r1ADqtfSdVCToUG868RvUUkgDKf31mGDtKsAYz2oz2AGutZYs")
    }

    func testDeriveFromXPub() {
        let xpub = "xpub6BosfCnifzxcFwrSzQiqu2DBVTshkCXacvNsWGYJVVhhawA7d4R5WSWGFNbi8Aw6ZRc1brxMyWMzG3DSSSSoekkudhUd9yLb6qx39T9nMdj"
        let bc = Bitcoin(purpose: .bip44)
        let xpubAddr2 = bc.derive(from: xpub, at: bc.derivationPath(at: 2))!
        let xpubAddr9 = bc.derive(from: xpub, at: bc.derivationPath(at: 9))!

        XCTAssertEqual(xpubAddr2.description, "1MNF5RSaabFwcbtJirJwKnDytsXXEsVsNb")
        XCTAssertEqual(xpubAddr9.description, "1DUrqK4hj6vNNUTWXADpbqyjVWUYFD7xTZ")
    }

    func testDeriveFromYPub() {
        let ypub = "ypub6Ww3ibxVfGzLrAH1PNcjyAWenMTbbAosGNB6VvmSEgytSER9azLDWCxoJwW7Ke7icmizBMXrzBx9979FfaHxHcrArf3zbeJJJUZPf663zsP"
        let bc = Bitcoin(purpose: .bip49)
        let ypubAddr3 = bc.derive(from: ypub, at: bc.derivationPath(at: 3))!
        let ypubAddr10 = bc.derive(from: ypub, at: bc.derivationPath(at: 10))!

        XCTAssertEqual(ypubAddr3.description, "38CahkVftQneLonbWtfWxiiaT2fdnzsEAN")
        XCTAssertEqual(ypubAddr10.description, "38mWd5D48ShYPJMZngtmxPQVYhQR5DGgfF")
    }

    func testDeriveFromZPub() {
        let zpub = "zpub6rFR7y4Q2AijBEqTUquhVz398htDFrtymD9xYYfG1m4wAcvPhXNfE3EfH1r1ADqtfSdVCToUG868RvUUkgDKf31mGDtKsAYz2oz2AGutZYs"
        let bc = Bitcoin()
        let zpubAddr4 = bc.derive(from: zpub, at: bc.derivationPath(at: 4))!
        let zpubAddr11 = bc.derive(from: zpub, at: bc.derivationPath(at: 11))!

        XCTAssertEqual(zpubAddr4.description, "bc1qm97vqzgj934vnaq9s53ynkyf9dgr05rargr04n")
        XCTAssertEqual(zpubAddr11.description, "bc1qxr4fjkvnxjqphuyaw5a08za9g6qqh65t8qwgum")
    }
}
