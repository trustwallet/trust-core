// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class EthereumAddressTests: XCTestCase {

    func testValidUpperCaseEthAddress() {
        XCTAssertTrue(EthereumAddress.isValid(string: "0xFA52274DD61E1643D2205169732F29114BC240B3"))
    }

    func testValidLoverCaseEthAddress() {
        XCTAssertTrue(EthereumAddress.isValid(string: "0xfa52274dd61e1643d2205169732f29114bc240b3"))
    }

    func testInvalid() {
        XCTAssertNil(EthereumAddress(string: "abc"))
        XCTAssertNil(EthereumAddress(string: "aaeb60f3e94c9b9a09f33669435e7ef1beaed"))
    }

    func testEIP55() {
        XCTAssertEqual(
            EthereumAddress(data: Data(hexString: "5aaeb6053f3e94c9b9a09f33669435e7ef1beaed")!)!.eip55String,
            "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed"
        )
        XCTAssertEqual(
            EthereumAddress(data: Data(hexString: "0x5AAEB6053F3E94C9b9A09f33669435E7Ef1BEAED")!)!.eip55String,
            "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed"
        )
        XCTAssertEqual(
            EthereumAddress(data: Data(hexString: "0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359")!)!.eip55String,
            "0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359"
        )
        XCTAssertEqual(
            EthereumAddress(data: Data(hexString: "0xdbF03B407c01E7cD3CBea99509d93f8DDDC8C6FB")!)!.eip55String,
            "0xdbF03B407c01E7cD3CBea99509d93f8DDDC8C6FB"
        )
        XCTAssertEqual(
            EthereumAddress(data: Data(hexString: "0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb")!)!.eip55String,
            "0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb"
        )
    }

    func testDescription() {
        let address = EthereumAddress(string: "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed")!
        XCTAssertEqual(address.description, "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed")
    }

    func testFromPrivateKey() {
        let privateKey = PrivateKey(data: Data(hexString: "afeefca74d9a325cf1d6b6911d61a65c32afa8e02bd5e78e2e4ac2910bab45f5")!)!
        let address = privateKey.publicKey().ethereumAddress

        XCTAssertEqual(address.description, "0xAc1ec44E4f0ca7D172B7803f6836De87Fb72b309")
    }

    func testIsValid() {
        XCTAssertFalse(EthereumAddress.isValid(string: "abc"))
        XCTAssertFalse(EthereumAddress.isValid(string: "5aaeb6053f3e94c9b9a09f33669435e7ef1beaed"))
        XCTAssertTrue(EthereumAddress.isValid(string: "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed"))

    }
}
