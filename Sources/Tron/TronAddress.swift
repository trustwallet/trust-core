// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct TronAddress: Address, Hashable {
    /// Validates that the raw data is a valid address.
    static public func isValid(data: Data) -> Bool {
        return data.count == Tron.addressSize
    }

    /// Validates that the string is a valid address.
    static public func isValid(string: String) -> Bool {
        //TODO: Implmenet
//        guard let data = Data(hexString: string) else {
//            return false
//        }
        return true
    }

    /// Raw address bytes, length 20.
    public let data: Data

    /// Creates an address with `Data`.
    ///
    /// - Precondition: data contains exactly 20 bytes
    public init?(data: Data) {
//        if !TronAddress.isValid(data: data) {
//            return nil
//        }
        self.data = data
    }

    /// Creates an address with an hexadecimal string representation.
    public init?(string: String) {
        guard let data = Crypto.base58Decode(string) else {
            return nil
        }
        self.data = data
    }

    public var description: String {
        return Crypto.base58Encode(data)
    }

    public var hashValue: Int {
        return data.hashValue
    }

    public static func == (lhs: TronAddress, rhs: TronAddress) -> Bool {
        return lhs.data == rhs.data
    }
}
