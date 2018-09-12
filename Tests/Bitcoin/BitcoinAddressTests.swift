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
        let address = Bitcoin().address(for: publicKey)

        XCTAssertEqual(address.description, "3Hv6oV8BYCoocW4eqZaEXsaR5tHhCxiMSk")
    }

    func testFromPrivateKeySegwitAddress() {
        let privateKey = PrivateKey(wif: "KxZX6Jv3to6RWnhsffTcLLryRnNyyc8Ng2G8P9LFkbCdzGDEhNy1")!
        let publicKey = privateKey.publicKey(compressed: true)
        let address = Bitcoin().legacyAddress(for: publicKey, prefix: 0x0)

        XCTAssertEqual(address.description, "1PeUvjuxyf31aJKX6kCXuaqxhmG78ZUdL1")
    }

    func testFromSewgitPrivateKey() {
        let privateKey = PrivateKey(wif: "L5XECLxq1MDvBeYXjZwz5tTYsFZRWmaYziY3Wvc2bqSRAuRcBqhg")!
        let publicKey = privateKey.publicKey(compressed: true)
        let address = Bitcoin().address(for: publicKey)

        XCTAssertEqual(address.description, "3Hv6oV8BYCoocW4eqZaEXsaR5tHhCxiMSk")
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
    }

    func testP2SHAddresses() {
        let privateKey = PrivateKey(data: Data(hexString: "65faa535a38572a9ec5440c393808eada67835eadd6c7ea3f1f31b5c5d36c446")!)!
        let publicKey = privateKey.publicKey()
        let compressedPublicKey = privateKey.publicKey(compressed: true)
        print(publicKey.data.hexString)
        print(compressedPublicKey.data.hexString)

        XCTAssertEqual(publicKey.bitcoinAddress(prefix: 0x00).base58String, "1KuAkM2x9HSot19FhUBMfPXxZjPF6rWvJ8")
        XCTAssertEqual(publicKey.bitcoinAddress(prefix: 0x05).base58String, "3LbBftXPhBmByAqgpZqx61ttiFfxjde2z7")

        XCTAssertEqual(compressedPublicKey.bitcoinAddress(prefix: 0x00).base58String, "17XqPKKXTYGHA3k38VRrL28KHicXsDBjTb")
        XCTAssertEqual(compressedPublicKey.bitcoinAddress(prefix: 0x05).base58String, "38DrJroy1SafFDSUFb6SkeVFSEuFUjwrUR")
    }
}
