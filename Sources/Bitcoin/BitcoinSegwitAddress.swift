// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct BitcoinSegwitAddress: Address, Equatable {
    // WitnessProgram.encoded
    public var data: Data

    public static func == (lhs: BitcoinSegwitAddress, rhs: BitcoinSegwitAddress) -> Bool {
        return lhs.data == rhs.data
    }

    public static func isValid(data: Data) -> Bool {
        return data.count == 33 && data[0] == 0x00
    }

    public static func isValid(string: String) -> Bool {
        var hrp: NSString?
        guard let data = Crypto.bech32Decode(string, hrp: &hrp),
            let readable = hrp as String?,
            BitcoinSegwitAddress.isValid(data: data),
            BitcoinSegwitAddress.validate(hrp: readable as String) else {
                return false
        }
        return true
    }

    public static func validate(hrp: String) -> Bool {
        return hrp == SLIP.HRP.bitcoin.rawValue
    }

    public init?(string: String) {
        var hrp: NSString?
        guard let data = Crypto.bech32Decode(string, hrp: &hrp),
            let readable = hrp as String?,
            BitcoinSegwitAddress.validate(hrp: readable as String) else {
            return nil
        }
        self.data = data
    }

    public init?(data: Data) {
        guard BitcoinSegwitAddress.isValid(data: data) else {
            return nil
        }
        self.data = data
    }

    public var description: String {
        return Crypto.bech32Encode(data, hrp: SLIP.HRP.bitcoin.rawValue)
    }
}
