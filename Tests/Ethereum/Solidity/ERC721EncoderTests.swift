// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import BigInt
import TrustCore
import XCTest

class ERC721EncoderTests: XCTestCase {

    let address = EthereumAddress(string: "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed")!
    let tokenId: BigUInt = 1234

    func testEncodeBalanceOf() {
        // ethabi encode function ./erc721.json balanceOf -p 5aaeb6053f3e94c9b9a09f33669435e7ef1beaed
        let expect = ERC721Encoder.encodeBalanceOf(owner: address)
        XCTAssertEqual(expect.hexString, "70a082310000000000000000000000005aaeb6053f3e94c9b9a09f33669435e7ef1beaed")
    }

    func testEncodeOwnerOf() {
        // ethabi encode function ./erc721.json ownerOf -p 00000000000000000000000000000000000000000000000000000000000004d2
        let expect = ERC721Encoder.encodeOwnerOf(tokenId: tokenId)
        XCTAssertEqual(expect.hexString, "6352211e00000000000000000000000000000000000000000000000000000000000004d2")
    }

    func testEncodeTransferFrom() {
        // ethabi encode function ./erc721.json transferFrom -p 5aaeb6053f3e94c9b9a09f33669435e7ef1beaed 5aaeb6053f3e94c9b9a09f33669435e7ef1beaed 00000000000000000000000000000000000000000000000000000000000004d2
        let expect = ERC721Encoder.encodeTransferFrom(from: address, to: address, tokenId: tokenId)
        XCTAssertEqual(expect.hexString, "23b872dd0000000000000000000000005aaeb6053f3e94c9b9a09f33669435e7ef1beaed0000000000000000000000005aaeb6053f3e94c9b9a09f33669435e7ef1beaed00000000000000000000000000000000000000000000000000000000000004d2")
    }

    func testEncodeSafeTransferFrom() {
        // ethabi encode function ./erc721.json safeTransferFrom -p 5aaeb6053f3e94c9b9a09f33669435e7ef1beaed 5aaeb6053f3e94c9b9a09f33669435e7ef1beaed 00000000000000000000000000000000000000000000000000000000000004d2
        let expect = ERC721Encoder.encodeSafeTransferFrom(from: address, to: address, tokenId: tokenId)
        XCTAssertEqual(expect.hexString, "42842e0e0000000000000000000000005aaeb6053f3e94c9b9a09f33669435e7ef1beaed0000000000000000000000005aaeb6053f3e94c9b9a09f33669435e7ef1beaed00000000000000000000000000000000000000000000000000000000000004d2")
    }

    func testEncodeTransfer() {
        XCTAssertEqual(ERC721Encoder.encodeTransfer(to: address, tokenId: 1).hexString, "a9059cbb000000000000000000000000\(address.data.hexString)0000000000000000000000000000000000000000000000000000000000000001")
    }

    func testEncodeApprove() {
        // ethabi encode function ./erc721.json approve -p 5aaeb6053f3e94c9b9a09f33669435e7ef1beaed 00000000000000000000000000000000000000000000000000000000000004d2
        let expect = ERC721Encoder.encodeApprove(approved: address, tokenId: tokenId)
        XCTAssertEqual(expect.hexString, "095ea7b30000000000000000000000005aaeb6053f3e94c9b9a09f33669435e7ef1beaed00000000000000000000000000000000000000000000000000000000000004d2")
    }

    func testEncodeSetApprovalForAll() {
        // ethabi encode function ./erc721.json setApprovalForAll -p 5aaeb6053f3e94c9b9a09f33669435e7ef1beaed true
        let expect = ERC721Encoder.encodeSetApprovalForAll(operator: address, approved: true)
        XCTAssertEqual(expect.hexString, "a22cb4650000000000000000000000005aaeb6053f3e94c9b9a09f33669435e7ef1beaed0000000000000000000000000000000000000000000000000000000000000001")
    }

    func testEncodeIsApprovedForAll() {
        // ethabi encode function ./erc721.json isApprovedForAll -p 5aaeb6053f3e94c9b9a09f33669435e7ef1beaed 5aaeb6053f3e94c9b9a09f33669435e7ef1beaed
        let expect = ERC721Encoder.encodeIsApprovedForAll(owner: address, operator: address)
        XCTAssertEqual(expect.hexString, "e985e9c50000000000000000000000005aaeb6053f3e94c9b9a09f33669435e7ef1beaed0000000000000000000000005aaeb6053f3e94c9b9a09f33669435e7ef1beaed")
    }

    func testEncodeGetApproved() {
        // ethabi encode function ./erc721.json getApproved -p 00000000000000000000000000000000000000000000000000000000000004d2
        let expect = ERC721Encoder.encodeGetApproved(tokenId: tokenId)
        XCTAssertEqual(expect.hexString, "081812fc00000000000000000000000000000000000000000000000000000000000004d2")
    }

    func testEncodeName() {
        // ethabi encode function ./erc721.json name
        let expect = ERC721Encoder.encodeName()
        XCTAssertEqual(expect.hexString, "06fdde03")
    }

    func testEncodeSymbol() {
        // ethabi encode function ./erc721.json symbol
        let expect = ERC721Encoder.encodeSymbol()
        XCTAssertEqual(expect.hexString, "95d89b41")
    }

    func testEncodeTokenURI() {
        // ethabi encode function ./erc721.json tokenURI -p 00000000000000000000000000000000000000000000000000000000000004d2
        let expect = ERC721Encoder.encodeTokenURI(tokenId: tokenId)
        XCTAssertEqual(expect.hexString, "c87b56dd00000000000000000000000000000000000000000000000000000000000004d2")
    }

    func testEncodeTotalSupply() {
        // ethabi encode function ./erc721.json totalSupply
        let expect = ERC721Encoder.encodeTotalSupply()
        XCTAssertEqual(expect.hexString, "18160ddd")
    }

    func testEncodeTokenByIndex() {
        // ethabi encode function ./erc721.json tokenByIndex -p 00000000000000000000000000000000000000000000000000000000000004d2
        let expect = ERC721Encoder.encodeTokenByIndex(index: tokenId)
        XCTAssertEqual(expect.hexString, "4f6ccce700000000000000000000000000000000000000000000000000000000000004d2")
    }

    func testEncodeTokenOfOwnerByIndex() {
        // ethabi encode function ./erc721.json tokenOfOwnerByIndex -p 5aaeb6053f3e94c9b9a09f33669435e7ef1beaed  00000000000000000000000000000000000000000000000000000000000004d2
        let expect = ERC721Encoder.encodeTokenOfOwnerByIndex(owner: address, index: tokenId)
        XCTAssertEqual(expect.hexString, "2f745c590000000000000000000000005aaeb6053f3e94c9b9a09f33669435e7ef1beaed00000000000000000000000000000000000000000000000000000000000004d2")
    }

    func testEncodeSupportsInterface() {
        // ethabi encode function ./erc721.json supportsInterface -p badbeeff
        let expect = ERC721Encoder.encodeSupportsInterface(interfaceID: Data(hexString: "0xbadbeeff")!)
        XCTAssertEqual(expect.hexString, "01ffc9a7badbeeff00000000000000000000000000000000000000000000000000000000")
    }
}
