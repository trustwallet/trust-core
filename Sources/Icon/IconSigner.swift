// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct IconSigner {
    let transaction: IconTransaction
    public var signature: Data?

    public init(transaction: IconTransaction) {
        self.transaction = transaction
    }

    public var txHashParams: [String: String] {
        var params: [String: String] = [:]
        params["from"] = transaction.from.description
        params["to"] = transaction.to.description
        let microsecondTimestamp = UInt64(transaction.timestamp.timeIntervalSince1970 * 1000 * 1000)
        params["timestamp"] = "0x" + String(format: "%llx", microsecondTimestamp)
        params["nonce"] = "0x" + String(transaction.nonce, radix: 16, uppercase: false)
        params["stepLimit"] = "0x" + String(transaction.stepLimit, radix: 16, uppercase: false)
        params["value"] = "0x" + String(transaction.value, radix: 16, uppercase: false)
        params["nid"] = "0x" + String(transaction.nid, radix: 16, uppercase: false)
        params["version"] = "0x" + String(transaction.version, radix: 16, uppercase: false)

        return params
    }

    public func txHash(for method: String) -> String {
        /// from: Wallet address of the sender - Format: ‘hx’ + 40 digit hex string
        /// to: Wallet address of the recipient - Format: ‘hx’ + 40 digit hex string
        /// value: Transfer amount (ICX) - Unit: 1/10^18 icx - Format: 0x + Hex string
        /// stepLimit: stepLimit is the amount of step to send with the transaction - Format: 0x + Hex string
        /// timestamp: UNIX epoch time (Begin from 1970.1.1 00:00:00) - Unit: microseconds
        /// nonce: Integer value increased by request to avoid ‘replay attack’
        /// nid: Network ID - Format: 0x + Hex string
        /// version: Protocol version ("0x3" for V3)

        var txHash = method
        let params = self.txHashParams
        for key in params.keys.sorted() {
            guard let value = params[key] else { continue }
            txHash += "." + key + "." + value
        }

        return txHash
    }

    /// Signs this transaction by filling in the signature value.
    public mutating func sign(method: String, hashSigner: (Data) throws -> Data) rethrows {
        let txHash = self.txHash(for: method)
        let data = Crypto.sha3_256(txHash.data(using: .utf8)!)
        self.signature = try hashSigner(data)
    }
}
