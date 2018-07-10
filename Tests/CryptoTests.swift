// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class CryptoTests: XCTestCase {
    func testSign() {
        let hash = Data(hexString: "3F891FDA3704F0368DAB65FA81EBE616F4AA2A0854995DA4DC0B59D2CADBD64F")!
        let privateKey = Data(hexString: "D30519BCAE8D180DBFCC94FE0B8383DC310185B0BE97B4365083EBCECCD75759")!
        let signature = Crypto.sign(hash: hash, privateKey: privateKey)
        let publicKey = Crypto.getPublicKey(from: privateKey)

        XCTAssertEqual(signature.count, 65)
        XCTAssertEqual(signature.hexString, "e56cfc6bddb0f803ee41c163816c3aa924ea0aae937294daf6a55f948aab8b463746cd528a3ad0102b431d7c7cecec7d92b910fe57c1213514c12206c41f1fef00")
        XCTAssertTrue(Crypto.verify(signature: signature, message: hash, publicKey: publicKey))
    }

    func testGetPublicKey() {
        let privateKey = Data(hexString: "7a28b5ba57c53603b0b07b56bba752f7784bf506fa95edc395f5cf6c7514fe9d")!
        XCTAssertEqual(Crypto.getPublicKey(from: privateKey).hexString, "0432d87c5cd4b31d81c5b010af42a2e413af253dc3a91bd3d53c6b2c45291c3de71633bf7793447a0d3ddde601f8d21668fca5b33324f14ebe7516eab0da8bab8f")
    }
}
