// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import BigInt

public struct WanchainTransactionType {
    public static let normal = BigInt(1)
    public static let privacy = BigInt(6)
}

public struct WanchainTransaction {
    public let type: WanchainTransactionType
    public var transaction: EthereumTransaction

    /// Signs this transaction by filling in the `v`, `r`, and `s` values.
    ///
    /// - Parameters:
    ///   - chainID: chain identifier, defaults to `1`
    ///   - hashSigner: function to use for signing the hash
    public mutating func sign(chainID: Int, hashSigner: (Data) throws -> Data) rethrows {
        let signer = WanchainSigner(chainID: BigInt(chainID))
        let hash = signer.hash(transaction: self)
        let signature = try hashSigner(hash)
        (transaction.r, transaction.s, transaction.v) = signer.values(signature: signature)
    }
}
