// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class IconAddressTests: XCTestCase {
    
    func testInvalid() {
        XCTAssertNil(IconAddress(string: "abc"))
        XCTAssertNil(IconAddress(string: "dshadghasdghsadadsadjsad"))
    }
    
    func testIsValid() {
        XCTAssertFalse(IconAddress.isValid(string: "abc"))
        XCTAssertFalse(IconAddress.isValid(string: "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed"))
        XCTAssertTrue(IconAddress.isValid(string: "hx116f042497e5f34268b1b91e742680f84cf4e9f3"))
    }
    
    func testFromPrivateKey() {
        let privateKey = PrivateKey(data: Data(hexString: "a8697743afbded16c4b57829394e557e11f39164e15e5ae704210ed09c3f9857")!)!
        let address = privateKey.publicKey().iconAddress
        XCTAssertEqual(address.description, "hx1d2b61e4bd800abecce8062281b46a03026e08fb")
    }
    
    func testDescription() {
        let address = IconAddress(string: "hx116f042497e5f34268b1b91e742680f84cf4e9f3")!
        XCTAssertEqual(address.description, "hx116f042497e5f34268b1b91e742680f84cf4e9f3")
    }
}
