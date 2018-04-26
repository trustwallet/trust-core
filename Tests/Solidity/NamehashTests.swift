// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore

class NamehashTests: XCTestCase {

    func testNamehash() {
        XCTAssertEqual(ENSEncoder.nameHash("").hexString, "0000000000000000000000000000000000000000000000000000000000000000")
        XCTAssertEqual(ENSEncoder.nameHash("eth").hexString, "93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae")
        XCTAssertEqual(ENSEncoder.nameHash("foo.eth").hexString, "de9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f")
        XCTAssertEqual(ENSEncoder.nameHash("bar.foo.eth").hexString, "275ae88e7263cdce5ab6cf296cdd6253f5e385353fe39cfff2dd4a2b14551cf3")
    }

    func testLabelhash() {
        XCTAssertEqual(ENSEncoder.labelHash("eth").hexString, "4f5b812789fc606be1b3b16908db13fc7a9adf7ca72641f84d75b47069d3d7f0")
        XCTAssertEqual(ENSEncoder.labelHash("bar").hexString, "435cd288e3694b535549c3af56ad805c149f92961bf84a1c647f7d86fc2431b4")
    }
}
