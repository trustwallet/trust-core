// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import BigInt
import TrustCore

public final class ERC721Encoder {
    /// Encodes a function call to `supportsInterface`
    ///
    /// Solidity function: `function supportsInterface(bytes4 _interfaceID) returns (bool);`
    public static func encodeSupportsInterface(interfaceID: Data) -> Data {
        let function = Function(name: "supportsInterface", parameters: [.bytes(4)])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [interfaceID])
        return encoder.data
    }
    /// Encodes a function call to `name`
    ///
    /// Solidity function: `function name() returns (string);`
    public static func encodeName() -> Data {
        let function = Function(name: "name", parameters: [])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [])
        return encoder.data
    }
    /// Encodes a function call to `getApproved`
    ///
    /// Solidity function: `function getApproved(uint256 _tokenId) returns (address);`
    public static func encodeGetApproved(tokenId: BigUInt) -> Data {
        let function = Function(name: "getApproved", parameters: [.uint(bits: 256)])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [tokenId])
        return encoder.data
    }
    /// Encodes a function call to `approve`
    ///
    /// Solidity function: `function approve(address _approved, uint256 _tokenId)`
    public static func encodeApprove(approved: EthereumAddress, tokenId: BigUInt) -> Data {
        let function = Function(name: "approve", parameters: [.address, .uint(bits: 256)])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [approved, tokenId])
        return encoder.data
    }
    /// Encodes a function call to `totalSupply`
    ///
    /// Solidity function: `function totalSupply() returns (uint256);`
    public static func encodeTotalSupply() -> Data {
        let function = Function(name: "totalSupply", parameters: [])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [])
        return encoder.data
    }
    /// Encodes a function call to `transferFrom`
    ///
    /// Solidity function: `function transferFrom(address _from, address _to, uint256 _tokenId)`
    public static func encodeTransferFrom(from: EthereumAddress, to: EthereumAddress, tokenId: BigUInt) -> Data {
        let function = Function(name: "transferFrom", parameters: [.address, .address, .uint(bits: 256)])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [from, to, tokenId])
        return encoder.data
    }
    /// Encodes a function call to `tokenOfOwnerByIndex`
    ///
    /// Solidity function: `function tokenOfOwnerByIndex(address _owner, uint256 _index) returns (uint256);`
    public static func encodeTokenOfOwnerByIndex(owner: EthereumAddress, index: BigUInt) -> Data {
        let function = Function(name: "tokenOfOwnerByIndex", parameters: [.address, .uint(bits: 256)])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [owner, index])
        return encoder.data
    }
    /// Encodes a function call to `safeTransferFrom`
    ///
    /// Solidity function: `function safeTransferFrom(address _from, address _to, uint256 _tokenId)`
    public static func encodeSafeTransferFrom(from: EthereumAddress, to: EthereumAddress, tokenId: BigUInt) -> Data {
        let function = Function(name: "safeTransferFrom", parameters: [.address, .address, .uint(bits: 256)])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [from, to, tokenId])
        return encoder.data
    }
    /// Encodes a function call to `tokenByIndex`
    ///
    /// Solidity function: `function tokenByIndex(uint256 _index) returns (uint256);`
    public static func encodeTokenByIndex(index: BigUInt) -> Data {
        let function = Function(name: "tokenByIndex", parameters: [.uint(bits: 256)])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [index])
        return encoder.data
    }
    /// Encodes a function call to `ownerOf`
    ///
    /// Solidity function: `function ownerOf(uint256 _tokenId) returns (address);`
    public static func encodeOwnerOf(tokenId: BigUInt) -> Data {
        let function = Function(name: "ownerOf", parameters: [.uint(bits: 256)])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [tokenId])
        return encoder.data
    }
    /// Encodes a function call to `balanceOf`
    ///
    /// Solidity function: `function balanceOf(address _owner) returns (uint256);`
    public static func encodeBalanceOf(owner: EthereumAddress) -> Data {
        let function = Function(name: "balanceOf", parameters: [.address])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [owner])
        return encoder.data
    }
    /// Encodes a function call to `owner`
    ///
    /// Solidity function: `function owner() returns (address);`
    public static func encodeOwner() -> Data {
        let function = Function(name: "owner", parameters: [])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [])
        return encoder.data
    }
    /// Encodes a function call to `symbol`
    ///
    /// Solidity function: `function symbol() returns (string);`
    public static func encodeSymbol() -> Data {
        let function = Function(name: "symbol", parameters: [])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [])
        return encoder.data
    }
    /// Encodes a function call to `burn`
    ///
    /// Solidity function: `function burn(address _owner, uint256 _tokenId)`
    public static func encodeBurn(owner: EthereumAddress, tokenId: BigUInt) -> Data {
        let function = Function(name: "burn", parameters: [.address, .uint(bits: 256)])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [owner, tokenId])
        return encoder.data
    }
    /// Encodes a function call to `setApprovalForAll`
    ///
    /// Solidity function: `function setApprovalForAll(address _operator, bool _approved)`
    public static func encodeSetApprovalForAll(operator: EthereumAddress, approved: Bool) -> Data {
        let function = Function(name: "setApprovalForAll", parameters: [.address, .bool])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [`operator`, approved])
        return encoder.data
    }
    /// Encodes a function call to `safeTransferFrom`
    ///
    /// Solidity function: `function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data)`
    public static func encodeSafeTransferFrom(from: EthereumAddress, to: EthereumAddress, tokenId: BigUInt, data: Data) -> Data {
        let function = Function(name: "safeTransferFrom", parameters: [.address, .address, .uint(bits: 256), .dynamicBytes])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [from, to, tokenId, data])
        return encoder.data
    }
    /// Encodes a function call to `tokenURI`
    ///
    /// Solidity function: `function tokenURI(uint256 _tokenId) returns (string);`
    public static func encodeTokenURI(tokenId: BigUInt) -> Data {
        let function = Function(name: "tokenURI", parameters: [.uint(bits: 256)])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [tokenId])
        return encoder.data
    }
    /// Encodes a function call to `mint`
    ///
    /// Solidity function: `function mint(address _to, uint256 _tokenId, string _uri)`
    public static func encodeMint(to: EthereumAddress, tokenId: BigUInt, uri: String) -> Data {
        let function = Function(name: "mint", parameters: [.address, .uint(bits: 256), .string])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [to, tokenId, uri])
        return encoder.data
    }
    /// Encodes a function call to `isApprovedForAll`
    ///
    /// Solidity function: `function isApprovedForAll(address _owner, address _operator) returns (bool);`
    public static func encodeIsApprovedForAll(owner: EthereumAddress, operator: EthereumAddress) -> Data {
        let function = Function(name: "isApprovedForAll", parameters: [.address, .address])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [owner, `operator`])
        return encoder.data
    }
    /// Encodes a function call to `transferOwnership`
    ///
    /// Solidity function: `function transferOwnership(address _newOwner)`
    public static func encodeTransferOwnership(newOwner: EthereumAddress) -> Data {
        let function = Function(name: "transferOwnership", parameters: [.address])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [newOwner])
        return encoder.data
    }
}
