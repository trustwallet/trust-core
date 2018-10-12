// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit

public struct TronSign {
    private let tronTransaction: Protocol_Transaction
    public var signature: Data?

    public init(tronTransaction: Protocol_Transaction) {
        self.tronTransaction = tronTransaction
    }

    /// Signs this transaction by filling in the signature value.
    ///
    /// - Parameters:
    ///   - hashSigner: function to use for signing the hash
    public mutating func sign(hashSigner: (Data) throws -> Data) throws {
        let data = try tronTransaction.rawData.serializedData()
        let hash = Crypto.sha256(data)
        (signature) = try hashSigner(hash)
    }
}
