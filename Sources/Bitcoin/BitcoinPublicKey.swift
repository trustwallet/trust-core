// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public final class BitcoinPublicKey: PublicKey {
    /// Validates that raw data is a valid public key.
    static public func isValid(data: Data) -> Bool {
        switch data.first {
        case 2, 3:
            return data.count == 33
        case 4, 6, 7:
            return data.count == 65
        default:
            return false
        }
    }

    /// Coin this key is for.
    public let coin = Coin.bitcoin

    /// Raw representation of the public key.
    public let data: Data

    /// Whether this is a compressed key.
    public var isCompressed: Bool {
        return data.count == 33 && data[0] == 2 || data[0] == 3
    }

    /// Address.
    public var address: Address {
        return address(prefix: Bitcoin.MainNet.payToScriptHashAddressPrefix)
    }

    /// Returns the public key address with the given prefix.
    public func address(prefix: UInt8) -> BitcoinAddress {
        let hash = Data([prefix]) + Crypto.sha256ripemd160(data)
        return BitcoinAddress(data: hash)!
    }

    /// Returns the public key hash.
    public var hash: Data {
        return Crypto.sha256ripemd160(data)
    }

    /// Creates a public key from a raw representation.
    public init?(data: Data) {
        if !BitcoinPublicKey.isValid(data: data) {
            return nil
        }
        self.data = data
    }

    public var description: String {
        return address.description
    }
}
