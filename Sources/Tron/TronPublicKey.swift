// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import BigInt

public final class TronPublicKey: PublicKey {
    /// Validates that raw data is a valid public key.
    static public func isValid(data: Data) -> Bool {
        if data.count != 65 {
            return false
        }
        return data[0] == 4
    }

    /// Coin this key is for.
    public let coin = Coin.tron

    /// Raw representation of the public key.
    public let data: Data

    /// Address.
    public var address: Address {
        let hash = Crypto.hash(data[1...])
        let address = Data(hexString: "41")! + Data(hash.suffix(Tron.addressSize))
        let sha256_1 = Crypto.sha256sha256(address)
        let checkSum = sha256_1[0...3]
        let addressSum = address + checkSum
        return TronAddress(data: addressSum)!
    }

    /// Creates a public key from a raw representation.
    public init?(data: Data) {
        if !TronPublicKey.isValid(data: data) {
            return nil
        }
        self.data = data
    }

    public var description: String {
        return data.hexString
    }
}

