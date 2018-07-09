// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct BitcoinAddress: Address, Hashable {
    /// Validates that the raw data is a valid address.
    static public func isValid(data: Data) -> Bool {
        if data.count != Bitcoin.addressSize + 1 {
            return false
        }
        if data[0] != Bitcoin.MainNet.pubKeyHash && data[0] != Bitcoin.TestNet.pubKeyHash {
            return false
        }
        return true
    }

    /// Validates that the string is a valid address.
    static public func isValid(string: String) -> Bool {
        guard let decoded = BitcoinCrypto.base58Decode(string, expectedSize: Bitcoin.addressSize + 1) else {
            return false
        }

        // Verify size
        if decoded.count != 1 + Bitcoin.addressSize {
            return false
        }

        // Verify network ID
        let networkID = decoded[0]
        if networkID != Bitcoin.MainNet.pubKeyHash && networkID != Bitcoin.TestNet.pubKeyHash {
            return false
        }

        return true
    }

    /// Raw representation of the address.
    public let data: Data

    /// Creates an address from a raw representation.
    public init?(data: Data) {
        if !BitcoinAddress.isValid(data: data) {
            return nil
        }
        self.data = data
    }

    /// Creates an address from a string representation.
    public init?(string: String) {
        guard let decoded = BitcoinCrypto.base58Decode(string, expectedSize: Bitcoin.addressSize + 1) else {
            return nil
        }

        // Verify size
        if decoded.count != 1 + Bitcoin.addressSize {
            return nil
        }

        // Verify network ID
        let networkID = decoded[0]
        if networkID != Bitcoin.MainNet.pubKeyHash && networkID != Bitcoin.TestNet.pubKeyHash {
            return nil
        }

        data = Data(decoded)
    }

    public var description: String {
        return BitcoinCrypto.base58Encode(data)
    }

    public var hashValue: Int {
        return data.hashValue
    }

    public static func == (lhs: BitcoinAddress, rhs: BitcoinAddress) -> Bool {
        return lhs.data == rhs.data
    }
}
