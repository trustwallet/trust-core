// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

/// Icon address.
public struct IconAddress: Address, Hashable {
    public static let size = 20
    public static let prefix = "hx"

    /// Validates that the raw data is a valid address.
    static public func isValid(data: Data) -> Bool {
        return data.count == IconAddress.size
    }

    /// Validates that the string is a valid address.
    static public func isValid(string: String) -> Bool {
        if string.hasPrefix(IconAddress.prefix) {
            ///Remove address prefix
            let address = String(string.dropFirst(2))
            guard let data = Data(hexString: address) else {
                return false
            }
            return IconAddress.isValid(data: data)
        }
        return false
    }

    /// Raw address bytes, length 20.
    public let data: Data

    /// Creates an address with `Data`.
    ///
    /// - Precondition: data contains exactly 20 bytes
    public init?(data: Data) {
        if !IconAddress.isValid(data: data) {
            return nil
        }
        self.data = data
    }

    /// Creates an address with an hexadecimal string representation.
    public init?(string: String) {
        var address = string
        if address.hasPrefix(IconAddress.prefix) {
            ///Remove prefix
            address = String(string.dropFirst(2))
        }
        guard let data = Data(hexString: address), data.count == IconAddress.size else {
            return nil
        }
        self.data = data
    }

    public var description: String {
        return IconAddress.prefix + data.hexString
    }

    public var hashValue: Int {
        return data.hashValue
    }

    public static func == (lhs: IconAddress, rhs: IconAddress) -> Bool {
        return lhs.data == rhs.data
    }
}
