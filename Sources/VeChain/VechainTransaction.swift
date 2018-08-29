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
        let rlp = RLP.encode(self)!
        let hash = Crypto.blake2b256(rlp)
        (signature) = try hashSigner(hash)
    }
}
