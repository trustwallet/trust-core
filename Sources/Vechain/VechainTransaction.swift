// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import BigInt

public struct VechainTransaction {

    public let chainTag: UInt8
    public let blockRef: UInt64
    public let expiration: UInt32
    public let clauses: [VechainClause]
    public let gasPriceCoef: UInt8
    public let gas: UInt64
    public let dependOn: Data
    public let nonce: UInt64
    public let reversed: [Data]
    public var signature: Data

    public init(
        chainTag: UInt8,
        blockRef: UInt64,
        expiration: UInt32,
        clauses: [VechainClause],
        gasPriceCoef: UInt8,
        gas: UInt64,
        dependOn: Data,
        nonce: UInt64,
        reversed: [Data] = [],
        signature: Data = Data()
    ) {
        self.chainTag = chainTag
        self.blockRef = blockRef
        self.expiration = expiration
        self.clauses = clauses
        self.gasPriceCoef = gasPriceCoef
        self.gas = gas
        self.dependOn = dependOn
        self.nonce = nonce
        self.reversed = reversed
        self.signature = signature
    }

    /// Signs this transaction by filling in the signature value.
    ///
    /// - Parameters:
    ///   - hashSigner: function to use for signing the hash
    public mutating func sign(hashSigner: (Data) throws -> Data) rethrows {
        let hash = RLP.encode(self)!
        (signature) = try hashSigner(hash)
    }
}


//chainTag : uint8, last byte of the genesis block ID.
//blockRef : uint64 Default is best block, The BlockRef(an eight-byte array) includes two parts: the first four bytes contains the block height (number) and the rest four bytes a part of the referred block’s ID.
//expiration : uint32 Default is 0 . Number of blocks that can be used to specify when the transaction expires[1].Specifically, Expiration+BlockRef[:4] defines the height of the latest block that the transaction can be packed into.
//clauses : array an array of “clause” objects each of which contains fields “To”, “Value” and “Data” to enable single “from” coupling with multiple “to”
//from : string ,20bytes, The address for the sending account.
//to (optional) : string,20bytes, The destination address of the message, left undefined for a contract-creation transaction.
//value(optional) :string(hex), The value transferred for the transaction in Wei, also the endowment if it’s a contract-creation transaction.
//gasPriceCoef :uint8 , Default is 0, gasPriceCoef required range of ∈[0,255] . [2]
//gas :uint64, The amount of gas to use for the transaction.
//    dependsOn: string, ID of the transaction on which the current transaction depends
//    nonce ：uint64 transaction nonce customizable by user .
//    reserved : array Must be empty array.
//    Signature : signature of the hash of the transaction body 𝛺, that is, 𝑠𝑖𝑔𝑛𝑎𝑡𝑢𝑟𝑒 = 𝑠𝑖𝑔𝑛(ℎ𝑎𝑠ℎ(𝛺), 𝑝𝑟𝑖𝑣𝑎𝑡𝑒_𝑘𝑒𝑦).
