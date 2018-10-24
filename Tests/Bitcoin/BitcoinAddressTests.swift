// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class BitcoinAddressTests: XCTestCase {
    func testInvalid() {
        XCTAssertNil(BitcoinAddress(string: "abc"))
        XCTAssertNil(BitcoinAddress(string: "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed"))
        XCTAssertNil(BitcoinAddress(string: "175tWpb8K1S7NmH4Zx6rewF9WQrcZv245W"))
    }

    func testInitWithString() {
        let address = BitcoinAddress(string: "1AC4gh14wwZPULVPCdxUkgqbtPvC92PQPN")

        XCTAssertNotNil(address)
        XCTAssertEqual(address!.description, "1AC4gh14wwZPULVPCdxUkgqbtPvC92PQPN")
    }

    func testFromPrivateKey() {
        let privateKey = PrivateKey(wif: "L5XECLxq1MDvBeYXjZwz5tTYsFZRWmaYziY3Wvc2bqSRAuRcBqhg")!
        let publicKey = privateKey.publicKey(compressed: true)
        let address = Bitcoin().compatibleAddress(for: publicKey)

        XCTAssertEqual(address.description, "3Hv6oV8BYCoocW4eqZaEXsaR5tHhCxiMSk")
    }

    func testFromPrivateKeyUncompressed() {
        let privateKey = PrivateKey(wif: "L5XECLxq1MDvBeYXjZwz5tTYsFZRWmaYziY3Wvc2bqSRAuRcBqhg")!
        let publicKey = privateKey.publicKey(compressed: false)
        let address = Bitcoin().compatibleAddress(for: publicKey)

        XCTAssertEqual(address.description, "3Hv6oV8BYCoocW4eqZaEXsaR5tHhCxiMSk")
    }

    func testFromPrivateKeySegwitAddress() {
        let privateKey = PrivateKey(wif: "KxZX6Jv3to6RWnhsffTcLLryRnNyyc8Ng2G8P9LFkbCdzGDEhNy1")!
        let publicKey = privateKey.publicKey(compressed: true)
        let address = Bitcoin().legacyAddress(for: publicKey, prefix: 0x0)

        XCTAssertEqual(address.description, Bitcoin().address(string: "1PeUvjuxyf31aJKX6kCXuaqxhmG78ZUdL1")!.description)
    }

    func testFromSewgitPrivateKey() {
        let privateKey = PrivateKey(wif: "L5XECLxq1MDvBeYXjZwz5tTYsFZRWmaYziY3Wvc2bqSRAuRcBqhg")!
        let publicKey = privateKey.publicKey(compressed: true)
        let address = Bitcoin().compatibleAddress(for: publicKey)

        XCTAssertEqual(address.description, Bitcoin().address(string: "3Hv6oV8BYCoocW4eqZaEXsaR5tHhCxiMSk")!.description)
    }

    func testIsValid() {
        XCTAssertFalse(BitcoinAddress.isValid(string: "abc"))
        XCTAssertFalse(BitcoinAddress.isValid(string: "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed"))
        XCTAssertFalse(BitcoinAddress.isValid(string: "175tWpb8K1S7NmH4Zx6rewF9WQrcZv245W"))
        XCTAssertTrue(BitcoinAddress.isValid(string: "1AC4gh14wwZPULVPCdxUkgqbtPvC92PQPN"))
    }

    func testCompressedPublicKey() {
        // compressed public key starting with 0x03 (greater than midpoint of curve)
        let compressedPK = PublicKey(data: Data(hexString: "030589ee559348bd6a7325994f9c8eff12bd5d73cc683142bd0dd1a17abc99b0dc")!)!
        XCTAssertTrue(compressedPK.isCompressed)
        XCTAssertEqual(compressedPK.legacyBitcoinAddress(prefix: 0).description, "1KbUJ4x8epz6QqxkmZbTc4f79JbWWz6g37")
    }

    func testUncompressedPublicKey() {
        // uncompressed public key, starting with 0x04. Contains both X and Y encoded
        let uncompressed = PublicKey(data: Data(hexString: "0479BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8")!)!
        XCTAssertFalse(uncompressed.isCompressed)
        XCTAssertEqual(uncompressed.legacyBitcoinAddress(prefix: 0).description, "1EHNa6Q4Jz2uvNExL497mE43ikXhwF6kZm")

        let uncompressed2 = PublicKey(data: Data(hexString: "04f028892bad7ed57d2fb57bf33081d5cfcf6f9ed3d3d7f159c2e2fff579dc341a07cf33da18bd734c600b96a72bbc4749d5141c90ec8ac328ae52ddfe2e505bdb")!)!
        XCTAssertFalse(uncompressed2.isCompressed)
        XCTAssertEqual(uncompressed2.compressed.data.hexString, "03f028892bad7ed57d2fb57bf33081d5cfcf6f9ed3d3d7f159c2e2fff579dc341a")
        XCTAssertEqual(uncompressed2.compressed.legacyBitcoinAddress(prefix: 0).description, "1J7mdg5rbQyUHENYdx39WVWK7fsLpEoXZy")

        let uncompressed3 = PublicKey(data: Data(hexString: "042de45bea3dada528eee8a1e04142d3e04fad66119d971b6019b0e3c02266b79142158aa83469db1332a880a2d5f8ce0b3bba542b3e32df0740ccbfb01c275e42")!)!
        XCTAssertFalse(uncompressed3.isCompressed)
        XCTAssertEqual(uncompressed3.compressed.data.hexString, "022de45bea3dada528eee8a1e04142d3e04fad66119d971b6019b0e3c02266b791")
        XCTAssertEqual(uncompressed3.compressed.legacyBitcoinAddress(prefix: 0).description, "17XqPKKXTYGHA3k38VRrL28KHicXsDBjTb")
    }

    func testPublicKeyToBech32Address() {
        let publicKey = PublicKey(data: Data(hexString: "0279BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798")!)!
        let bitcoin = Bitcoin()
        let expect = "bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4"
        XCTAssertTrue(BitcoinSegwitAddress.isValid(string: expect))

        let address = bitcoin.address(for: publicKey)
        XCTAssertEqual(address.description, expect)

        let addressFromString = BitcoinSegwitAddress(string: expect)
        XCTAssertEqual(address as? BitcoinSegwitAddress, addressFromString)
    }

    func testWitnessProgramToBech32Address() {
        let address = BitcoinSegwitAddress(string: "bc1qr583w2swedy2acd7rung055k8t3n7udp7vyzyg")!
        let scriptPubKey = BitcoinScript.buildPayToWitnessPubkeyHash(WitnessProgram.from(bech32: address.description)!.program)
        XCTAssertEqual(scriptPubKey.data.hexString, "00141d0f172a0ecb48aee1be1f2687d2963ae33f71a1")
    }

    func testInvalidBech32Addresses() {
        let addresses = [
            "tc1qw508d6qejxtdg4y5r3zarvary0c5xw7kg3g4ty",
            "bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t5",
            "BC13W508D6QEJXTDG4Y5R3ZARVARY0C5XW7KN40WF2",
            "bc1rw5uspcuh",
            "bc10w508d6qejxtdg4y5r3zarvary0c5xw7kw508d6qejxtdg4y5r3zarvary0c5xw7kw5rljs90",
            "BC1QR508D6QEJXTDG4Y5R3ZARVARYV98GJ9P",
            "tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sL5k7",
            "bc1zw508d6qejxtdg4y5r3zarvaryvqyzf3du",
            "tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3pjxtptv",
            "bc1gmk9yu",
        ]

        for invalid in addresses {
            XCTAssertFalse(BitcoinSegwitAddress.isValid(string: invalid))
        }
    }

    func testLegacyAddresses() {
        let privateKey = PrivateKey(wif: "KzdwksguQ3NY8u1JNkZdgRroeLa2UJP2fz47KGgL2W91CQkC3Eww")!
        let publicKey = privateKey.publicKey(compressed: false)
        let compressedPublicKey = privateKey.publicKey(compressed: true)

        XCTAssertEqual(publicKey.legacyBitcoinAddress(prefix: 0x00).base58String, "1KuAkM2x9HSot19FhUBMfPXxZjPF6rWvJ8")
        XCTAssertEqual(publicKey.legacyBitcoinAddress(prefix: 0x05).base58String, "3LbBftXPhBmByAqgpZqx61ttiFfxjde2z7")

        XCTAssertEqual(compressedPublicKey.legacyBitcoinAddress(prefix: 0x00).base58String, "17XqPKKXTYGHA3k38VRrL28KHicXsDBjTb")
        XCTAssertEqual(compressedPublicKey.legacyBitcoinAddress(prefix: 0x05).base58String, "38DrJroy1SafFDSUFb6SkeVFSEuFUjwrUR")
    }
}
