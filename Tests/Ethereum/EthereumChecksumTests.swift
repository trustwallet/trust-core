// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore

class EthereumChecksumTests: XCTestCase {

    func testEIP55() {

        XCTAssertEqual(
            EthereumChecksum.computeString(for: Data(hexString: "5aaeb6053f3e94c9b9a09f33669435e7ef1beaed")!, type: .EIP55),
            "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed"
        )
        XCTAssertEqual(
            EthereumChecksum.computeString(for: Data(hexString: "0x5AAEB6053F3E94C9b9A09f33669435E7Ef1BEAED")!, type: .EIP55),
            "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed"
        )
        XCTAssertEqual(
            EthereumChecksum.computeString(for: Data(hexString: "0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359")!, type: .EIP55),
            "0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359"
        )
        XCTAssertEqual(
            EthereumChecksum.computeString(for: Data(hexString: "0xdbF03B407c01E7cD3CBea99509d93f8DDDC8C6FB")!, type: .EIP55),
            "0xdbF03B407c01E7cD3CBea99509d93f8DDDC8C6FB"
        )
        XCTAssertEqual(
            EthereumChecksum.computeString(for: Data(hexString: "0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb")!, type: .EIP55),
            "0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb"
        )
    }

    func testWanchain() {
        XCTAssertEqual(
            EthereumChecksum.computeString(for: Data(hexString: "5aaeb6053f3e94c9b9a09f33669435e7ef1beaed")!, type: .Wanchain),
            "0x5AaEB6053f3e94c9B9a09F33669435e7eF1bEaED"
        )
        XCTAssertEqual(
            EthereumChecksum.computeString(for: Data(hexString: "0x5AAEB6053F3E94C9b9A09f33669435E7Ef1BEAED")!, type: .Wanchain),
            "0x5AaEB6053f3e94c9B9a09F33669435e7eF1bEaED"
        )
        XCTAssertEqual(
            EthereumChecksum.computeString(for: Data(hexString: "0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359")!, type: .Wanchain),
            "0xFb6916095CA1DF60Bb79cE92Ce3eA74C37C5D359"
        )
        XCTAssertEqual(
            EthereumChecksum.computeString(for: Data(hexString: "0xdbF03B407c01E7cD3CBea99509d93f8DDDC8C6FB")!, type: .Wanchain),
            "0xDBf03b407C01e7Cd3cbEA99509D93F8dddc8c6fb"
        )
        XCTAssertEqual(
            EthereumChecksum.computeString(for: Data(hexString: "0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb")!, type: .Wanchain),
            "0xd1220a0CF47C7b9bE7a2e6ba89f429762E7B9AdB"
        )
    }
}
