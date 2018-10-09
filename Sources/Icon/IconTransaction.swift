// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import BigInt

public struct IconTransaction {
    public let from: IconAddress
    public let to: IconAddress
    public let value: BigInt
    public let fee: BigInt
    public let timestamp: String
    public let nonce: BigInt
    public var tx_hash: Data
    public var signature: Data

    public init(
        from: IconAddress,
        to: IconAddress,
        value: BigInt,
        fee: BigInt,
        timestamp: String,
        nonce: BigInt,
        tx_hash: Data = Data(),
        signature: Data = Data()
    ) {
        self.from = from
        self.to = to
        self.value = value
        self.fee = fee
        self.timestamp = timestamp
        self.nonce = nonce
        self.tx_hash = tx_hash
        self.signature = signature
    }

    public mutating func hash() {
        /// from: Wallet address of the sender - Format: ‘hx’ + 40 digit hex string
        /// to: Wallet address of the recipient - Format: ‘hx’ + 40 digit hex string
        /// value: Transfer amount (ICX) - Unit: 1/10^18 icx - Format: 0x + Hex string
        /// fee: Fee for the transaction - Unit: 1/10^18 icx - Format: 0x + Hex string
        /// timestamp: UNIX epoch time (Begin from 1970.1.1 00:00:00) - Unit: microseconds
        /// nonce: Integer value increased by request to avoid ‘replay attack’
        let txStr = "icx_sendTransaction" +
            ".fee." + "0x" + String(fee, radix: 16, uppercase: false) +
            ".from." + from.description +
            ".nonce." + String(nonce) +
            ".timestamp." + timestamp +
            ".to." + to.description +
            ".value." + "0x" + String(value, radix: 16, uppercase: false)

        tx_hash = Crypto.sha3_256(txStr.data(using: .utf8)!)
    }

    /// Signs this transaction by filling in the signature value.
    public mutating func sign(privateKey: PrivateKey) {
        if !tx_hash.isEmpty {
            signature = privateKey.sign(hash: tx_hash)
        }
    }

    /// Verifies signature
    public func verify(publicKey: PublicKey) -> Bool {
        if tx_hash.isEmpty || signature.isEmpty {
            return false
        }
        return Crypto.verify(signature: signature, message: tx_hash, publicKey: publicKey.data)
    }
}
