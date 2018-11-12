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
}
