// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public enum IconAddressPrefix: String {
    case address = "hx"
    case contract = "cx"
}

/// Icon address.
public struct IconAddress: Address, Hashable {
    public static let size = 20

    /// Validates that the raw data is a valid address.
    static public func isValid(data: Data) -> Bool {
        return data.count == IconAddress.size
    }

    /// Validates that the string is a valid address.
    static public func isValid(string: String) -> Bool {
        guard let _ = IconAddressPrefix(rawValue: String(string.prefix(2))) else {
            return false
        }
        guard let data = Data(hexString: String(string.dropFirst(2))) else {
            return false
        }
        return IconAddress.isValid(data: data)
    }

    /// Raw address bytes, length 20.
    public let data: Data

    public let type: IconAddressPrefix

    /// Creates an address with `Data`.
    ///
    /// - Precondition: data contains exactly 20 bytes
    public init?(data: Data) {
        if !IconAddress.isValid(data: data) {
            return nil
        }
        self.data = data
        self.type = .address
    }

    /// Creates an address with an hexadecimal string representation.
    public init?(string: String) {
        guard
            let prefix = IconAddressPrefix(rawValue: String(string.prefix(2))),
            let data = Data(hexString: String(string.dropFirst(2))),
            data.count == IconAddress.size else { return nil }
        self.data = data
        self.type = prefix
    }

    public var description: String {
        return type.rawValue + data.hexString
    }

    public var hashValue: Int {
        return data.hashValue
    }

    public static func == (lhs: IconAddress, rhs: IconAddress) -> Bool {
        return lhs.data == rhs.data
    }
}
