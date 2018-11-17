// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public typealias BitcoinSegwitAddress = BitcoinBech32Address

public struct BitcoinBech32Address: Address, Equatable {
    // bech32 data
    public var data: Data
    public let hrp: String

    public static func == (lhs: BitcoinBech32Address, rhs: BitcoinBech32Address) -> Bool {
        return lhs.data == rhs.data && lhs.hrp == rhs.hrp
    }

    public static func isValid(data: Data) -> Bool {
        return data.count == 33 && data[0] == 0x00
    }

    public static func isValid(string: String) -> Bool {
        guard let (data, _) = BitcoinBech32Address.bech32Decode(string: string) else {
            return false
        }
        return BitcoinBech32Address.isValid(data: data)
    }

    public static func validate(hrp: String) -> Bool {
        return SLIP.HRP.allSet.contains(hrp)
    }

    public static func bech32Decode(string: String) -> (Data, String)? {
        var hrp: NSString?
        guard let data = Crypto.bech32Decode(string, hrp: &hrp),
            let readable = hrp as String?,
            BitcoinBech32Address.validate(hrp: readable as String) else {
                return nil
        }
        return (data, readable)
    }

    public init?(string: String) {
        guard let (data, hrp) = BitcoinBech32Address.bech32Decode(string: string) else {
            return nil
        }
        self.data = data
        self.hrp = hrp
    }

    public init?(data: Data) {
        guard BitcoinBech32Address.isValid(data: data) else {
            return nil
        }
        self.data = data
        self.hrp = SLIP.HRP.bitcoin.rawValue
    }

    public init?(data: Data, hrp: String) {
        guard BitcoinBech32Address.isValid(data: data) else {
            return nil
        }
        guard BitcoinBech32Address.validate(hrp: hrp) else {
            return nil
        }
        self.data = data
        self.hrp = hrp
    }

    public var description: String {
        return Crypto.bech32Encode(data, hrp: hrp)
    }
}
