// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore
import BigInt

class ENSEncoderTests: XCTestCase {
    let address = Address(string: "0x5aaeb6053f3e94c9b9a09f33669435e7ef1beaed")!
    let label = "bar"
    let node = "foo.eth"

    func testEncodeOwner() {
        // ethabi encode function ./ens_abi.json owner -p de9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f
        let result = ENSEncoder.encodeOwner(node: ENSEncoder.nameHash(node))
        XCTAssertEqual(result.hexString, "02571be3de9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f")
    }

    func testEncodeSetOwner() {
        // ethabi encode function ./ens_abi.json setOwner -p de9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f 5aaeb6053f3e94c9b9a09f33669435e7ef1beaed
        let result = ENSEncoder.encodeSetOwner(node: ENSEncoder.nameHash(node), owner: address)
        XCTAssertEqual(result.hexString, "5b0fc9c3de9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f0000000000000000000000005aaeb6053f3e94c9b9a09f33669435e7ef1beaed")
    }

    func testEncodeResolver() {
        // ethabi encode function ./ens_abi.json resolver -p de9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f
        let result = ENSEncoder.encodeResolver(node: ENSEncoder.nameHash(node))
        XCTAssertEqual(result.hexString, "0178b8bfde9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f")
    }

    func testEncodeSetResolver() {
        // ethabi encode function ./ens_abi.json setResolver -p de9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f 5aaeb6053f3e94c9b9a09f33669435e7ef1beaed
        let result = ENSEncoder.encodeSetResolver(node: ENSEncoder.nameHash(node), resolver: address)
        XCTAssertEqual(result.hexString, "1896f70ade9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f0000000000000000000000005aaeb6053f3e94c9b9a09f33669435e7ef1beaed")
    }

    func testEncodeSetSubnodeOwner() {
        // ethabi encode function ./ens_abi.json setSubnodeOwner -p de9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f 435cd288e3694b535549c3af56ad805c149f92961bf84a1c647f7d86fc2431b4 5aaeb6053f3e94c9b9a09f33669435e7ef1beaed
        let result = ENSEncoder.encodeSetSubnodeOwner(node: ENSEncoder.nameHash(node), label: ENSEncoder.labelHash(label), owner: address)
        XCTAssertEqual(result.hexString, "06ab5923de9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f435cd288e3694b535549c3af56ad805c149f92961bf84a1c647f7d86fc2431b40000000000000000000000005aaeb6053f3e94c9b9a09f33669435e7ef1beaed")
    }

    func testEncodeTTL() {
        // ethabi encode function ./ens_abi.json ttl -p de9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f
        let result = ENSEncoder.encodeTTL(node: ENSEncoder.nameHash(node))
        XCTAssertEqual(result.hexString, "16a25cbdde9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f")
    }

    func testEncodeSetTTL() {
        // ethabi encode function ./ens_abi.json setTTL -p de9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f 0000000000000000000000000000000000000000000000000000000003c26700
        let ttl: UInt64 = 2 * 365 * 24 * 60 * 60
        let result = ENSEncoder.encodeSetTTL(node: ENSEncoder.nameHash(node), ttl: ttl)
        XCTAssertEqual(result.hexString, "14ab9038de9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f0000000000000000000000000000000000000000000000000000000003c26700")
    }
}
