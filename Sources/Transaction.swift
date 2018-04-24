// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import BigInt

/// Ethereum transaction.
public struct Transaction {
    public var accountNonce: UInt64
    public var price: BigInt
    public var gasLimit: UInt64
    public var recipient: Address
    public var amount: BigInt
    public var payload: Data?

    // Signature values
    public var v = BigInt()
    public var r = BigInt()
    public var s = BigInt()

    /// Creates a `Transaction` with default values and the given recipient address.
    public init(recipient: Address) {
        accountNonce = 0
        price = BigInt()
        gasLimit = 0
        self.recipient = recipient
        amount = BigInt()
    }

    /// Signs this transaction by filling in the `v`, `r`, and `s` values.
    ///
    /// - Parameters:
    ///   - chainID: chain identifier, defaults to `1`
    ///   - hashSigner: function to use for signing the hash
    public mutating func sign(chainID: Int = 1, hashSigner: (Data) throws -> Data) rethrows {
        let signer: Signer
        if chainID == 0 {
            signer = HomesteadSigner()
        } else {
            signer = EIP155Signer(chainID: BigInt(chainID))
        }

        let hash = signer.hash(transaction: self)
        let signature = try hashSigner(hash)
        (r, s, v) = signer.values(transaction: self, signature: signature)
    }
}
