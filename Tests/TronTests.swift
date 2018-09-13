// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class TronAddressTests: XCTestCase {
    func testAddress() {
        let privateKey = PrivateKey(data: Data(hexString: "BE88DF1D0BF30A923CB39C3BB953178BAAF3726E8D3CE81E7C8462E046E0D835")!)!
        let blockchain = Tron()
        XCTAssertEqual("THRF3GuPnvvPzKoaT8pJex5XHmo8NNbCb3", blockchain.address(for: privateKey.publicKey()).description)
    }
}
