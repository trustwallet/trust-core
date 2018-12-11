// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import TrezorCrypto

/// Ethereum address.
public struct AionAddress: Address, Hashable {
    public static let size = 32
    public static let prefix = "a0"

    /// Validates that the raw data is a valid address.
    static public func isValid(data: Data) -> Bool {
        return data.count == AionAddress.size
    }

    /// Validates that the string is a valid address.
    static public func isValid(string: String) -> Bool {
        guard AionAddress.prefix == String(string.prefix(2)) else {
            return false
        }

        guard let data = Data(hexString: String(string.dropFirst(2))) else {
            return false
        }

        return AionAddress.isValid(data: data)
    }

    /// Raw address bytes, length 20.
    public let data: Data

    /// Creates an address with `Data`.
    ///
    /// - Precondition: data contains exactly 20 bytes
    public init?(data: Data) {
        guard AionAddress.isValid(data: data) else {
            return nil
        }

        self.data = data
    }

    /// Creates an address with an hexadecimal string representation.
    public init?(string: String) {
        guard AionAddress.prefix == string.prefix(2), let data = Data(hexString: String(string.dropFirst(2))), AionAddress.isValid(data: data) else {
            return nil
        }

        self.init(data: data)
    }

    public var description: String {
        return AionAddress.prefix + data.hexString
    }

    public var hashValue: Int {
        return data.hashValue
    }

    public static func == (lhs: AionAddress, rhs: AionAddress) -> Bool {
        return lhs.data == rhs.data
    }
}
