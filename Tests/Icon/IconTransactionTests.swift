// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore
import BigInt

class IconTransactionTests: XCTestCase {

    func testSignTransaction() {

        let privateKey = PrivateKey(data: Data(hexString: "2d42994b2f7735bbc93a3e64381864d06747e574aa94655c516f9ad0a74eed79")!)!
        let transaction: IconTransaction = IconTransaction(
            from: IconAddress(string: "hxbe258ceb872e08851f1f59694dac2558708ece11")!,
            to: IconAddress(string: "hx5bfdb090f43a808005ffc27c25b213145e80b7cd")!,
            value: BigInt("1000000000000000000"),
            stepLimit: BigInt("74565"),
            timestamp: Date(timeIntervalSince1970: 1516942975.500598),
            nonce: BigInt("1"),
            nid: BigInt("1"),
            version: BigInt("3"))

        let method = "icx_sendTransaction"
        var signer = IconSigner(transaction: transaction)
        signer.sign(method: method) { (data) -> Data in
            return Crypto.sign(hash: data, privateKey: privateKey.data)
        }

        XCTAssertEqual(signer.txHash(for: method), "icx_sendTransaction.from.hxbe258ceb872e08851f1f59694dac2558708ece11.nid.0x1.nonce.0x1.stepLimit.0x12345.timestamp.0x563a6cf330136.to.hx5bfdb090f43a808005ffc27c25b213145e80b7cd.value.0xde0b6b3a7640000.version.0x3")
        XCTAssertEqual(signer.signature?.base64EncodedString(), "xR6wKs+IA+7E91bT8966jFKlK5mayutXCvayuSMCrx9KB7670CsWa0B7LQzgsxU0GLXaovlAT2MLs1XuDiSaZQE=")
    }
}

