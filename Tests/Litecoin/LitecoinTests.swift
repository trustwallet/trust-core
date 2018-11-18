// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class LitecoinTests: XCTestCase {
    func testAddress() {
        let litcoin = Litecoin()
        let privateKey1 = PrivateKey(wif: "T8VERgAiBcUnRXmWxgVzp6AaH1hKwPQQQeghi3n9ZY6nF59GuTJf")!
        let publicKey1 = privateKey1.publicKey(compressed: true)

        let legacyAddress = litcoin.legacyAddress(for: publicKey1)
        XCTAssertEqual(LitecoinAddress(string: "LV7LV7Z4bWDEjYkfx9dQo6k6RjGbXsg6hS")!.description, legacyAddress.description)

        let privateKey2 = PrivateKey(wif: "TBKynom8diHvD7TzpURLY2EHP6MbR7iYiaD6fGPiTB5pHbxSNXgH")!
        let publicKey2 = privateKey2.publicKey(compressed: true)
        let compatibleAddress = litcoin.compatibleAddress(for: publicKey2)
        XCTAssertEqual(LitecoinAddress(string: "M8eTgzhoFTErAjkGa6cyBomcHfxAprbDgD")!.description, compatibleAddress.description)

        let privateKey3 = PrivateKey(wif: "T5w6v6RpidKc8JMMcRDi6f6xTaEVV52LG2W73mCVesA4ZGWef2xA")!
        let publicKey3 = privateKey3.publicKey(compressed: true)
        let bech32Address = litcoin.address(for: publicKey3)
        XCTAssertEqual(LitecoinBech32Address(string: "ltc1qytnqzjknvv03jwfgrsmzt0ycmwqgl0asjnaxwu")!.description, bech32Address.description)
    }

    func testDeriveFromLtub() {
        let xpub = "Ltub2Ye6FtTv7U4zzHDL6iMfcE3cj5BHJjkBXQj1deZEAgSBrHB5oM191hYTF8BC34r7vRDGng59yfP6FH4m3nttc3TLDg944G8QK7d5NnygCRu"
        let bc = Litecoin(purpose: .bip44)
        let xpubAddr2 = bc.derive(from: xpub, at: bc.derivationPath(at: 2))!
        let xpubAddr9 = bc.derive(from: xpub, at: bc.derivationPath(at: 9))!

        XCTAssertEqual(xpubAddr2.description, "LdJvSS8gcRSN1WbSEj6srV8dKzGcybHGKt")
        XCTAssertEqual(xpubAddr9.description, "Laj4byUKgW3wuou4G3XCAPWqzVc3SdEpQk")
    }

    func testDeriveFromMtub() {
        let ypub = "Mtub2sZjeBCxVccvybLHSD1i3Aw38QvCTDadaPyXbSkRRX1RQm3mxtfsbQU5M3PdCSP4xAFHCceEQ3FmQF69Du2wbcmebt3CaWAGALBSe8c4Gvw"
        let bc = Litecoin(purpose: .bip49)
        let ypubAddr3 = bc.derive(from: ypub, at: bc.derivationPath(at: 3))!
        let ypubAddr10 = bc.derive(from: ypub, at: bc.derivationPath(at: 10))!

        XCTAssertEqual(ypubAddr3.description, "MVr2vvjyaTzmfX3LFZcg5KZ7Cc36pgAWcy")
        XCTAssertEqual(ypubAddr10.description, "MTgkF6T5h92QDmpFsBk4fJeYt3dx5ERQtD")
    }

    func testDeriveFromZPub() {
        let zpub = "zpub6sCFp8chadVDXVt7GRmQFpq8B7W8wMLdFDto1hXu2jLZtvkFhRnwScXARNfrGSeyhR8DBLJnaUUkBbkmB2GwUYkecEAMUcbUpFQV4v7PXcs"
        let bc = Litecoin()
        let zpubAddr4 = bc.derive(from: zpub, at: bc.derivationPath(at: 4))!
        let zpubAddr11 = bc.derive(from: zpub, at: bc.derivationPath(at: 11))!

        XCTAssertEqual(zpubAddr4.description, "ltc1qcgnevr9rp7aazy62m4gen0tfzlssa52axwytt6")
        XCTAssertEqual(zpubAddr11.description, "ltc1qy072y8968nzp6mz3j292h8lp72d678fcmms6vl")
    }

    func testLockScripts() {
        let bc = Litecoin()
        let address = LitecoinBech32Address(string: "ltc1qs32zgdhe2tpzcnz55r7d9jvhce33063sfht3q0")!
        let scriptPub = bc.buildScript(for: address)!
        XCTAssertEqual(scriptPub.data.hexString, "001484542436f952c22c4c54a0fcd2c997c66317ea30")

        let address2 = LitecoinAddress(string: "MHhghmmCTASDnuwpgsPUNJVPTFaj61GzaG")!
        let scrpitPub2 = bc.buildScript(for: address2)!
        XCTAssertEqual(scrpitPub2.data.hexString, "a9146b85b3dac9340f36b9d32bbacf2ffcb0851ef17987")

        let address3 = LitecoinAddress(string: "LgKiekick9Ka7gYoYzAWGrEq8rFBJzYiyf")!
        let scrpitPub3 = bc.buildScript(for: address3)!
        XCTAssertEqual(scrpitPub3.data.hexString, "76a914e771c6695c5dd189ccc4ef00cd0f3db3096d79bd88ac")
    }
}
