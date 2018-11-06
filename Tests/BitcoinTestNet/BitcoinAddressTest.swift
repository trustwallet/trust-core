// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
@testable import TrustCore

class BitcoinTestNetAddressTests: XCTestCase {
    
    func testAddresses() {
        let privateKey = PrivateKey(wif: "Kwi8EArppSCAiMRNNHE9u8HF5p26MzW7U3uoUipyq9xisEAazPaF")!
        let pub = privateKey.publicKey(compressed: true)
        let pubs = [pub,pub]
        
        let uncompressedPub = privateKey.publicKey(compressed: false)
        let pubs_uncompressed = [uncompressedPub,uncompressedPub]
        
        //P2PKH Address
        let address_P2PKH = pub.legacyBitcoinAddress(prefix: 0x6F)
        XCTAssertEqual(address_P2PKH.description, "miyV5UgyEyG8kiueMvxX3NnLug7vbtoCtA")
        
        //multi_P2SH Address
        let address_multi_P2SH = BitcoinTestNet().multiSigAddress((pubs_uncompressed, 1))
        XCTAssertEqual(address_multi_P2SH!.description, "2Muj4yF9hSDyf93AQNeY8oAbe59mGpyTPM9")
        
        //P2WPKH Address
        let address_P2WPKH_P2SH = pub.bitcoinTestNetBech32Address()
        XCTAssertEqual(address_P2WPKH_P2SH.description, "tb1qyhkw8rzzpwap78625yjkqzcpl2djdafucjcga7")

        //P2WSH Address
        let address_P2WSH = BitcoinTestNet().multiP2WSHAddress((pubs, 1))
        XCTAssertEqual(address_P2WSH!.description, "tb1qsx7kgknk045wucgkawzmtvjeweqwfk033mcjqnc9x0d6u7ujn05s043qx5")
        
        //P2WSH_in_P2SH Address
        let address_P2WSH_in_P2SH = BitcoinTestNet().multiP2WSHNestedInP2SHAddress((pubs, 1))
        XCTAssertEqual(address_P2WSH_in_P2SH!.description, "2N8ayNRBsispZUq4ma1GMFMoH4wC4o3hLzC")
        
        //P2WPKH_in_P2SH Address
        let address_P2WPKH_in_P2SH = pub.compatibleBitcoinAddress(prefix: 0xC4)
        XCTAssertEqual(address_P2WPKH_in_P2SH.description, "2N3fyutnN34Yekedzs5b724nkFrWdh1XbUM")

    }
}
