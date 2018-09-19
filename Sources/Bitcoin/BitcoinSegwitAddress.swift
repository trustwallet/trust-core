// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct WitnessProgram: Equatable {

    public let version: UInt8
    public let program: Data

    var encoded: Data {
        var data = Data(bytes: [version])
        if let bits = convertBits(program, from: 8, to: 5) {
            data.append(bits)
        }
        return data
    }

    var valid: Bool {
        if version > 16 {
            // Invalid script version
            return false
        }
        if program.count < 2 || program.count > 20 {
            return false
        }
        if version == 0 && program.count != 20 && program.count != 32 {
            return false
        }
        return true
    }

    func convertBits(_ data: Data, from: UInt32, to: UInt32, pad: Bool = true) -> Data? {
        var ret = Data()
        if from > 8 || to > 8 {
            return nil
        }
        var acc: UInt32 = 0
        var bits: UInt32 = 0
        let maxv: UInt32 = (1 << to) - 1
        for value in data {
            let v = UInt32(value)
            if (v >> from) != 0 {
                // Input value exceeds `from` bit size
                return nil
            }
            acc = (acc << from) | v
            bits += from
            while bits >= to {
                bits -= to
                ret.append(UInt8((acc >> bits) & maxv))
            }
        }
        if pad {
            if bits > 0 {
                ret.append(UInt8((acc << (to - bits)) & maxv))
            }
        } else if bits >= from || ((acc << (to - bits)) & maxv) != 0 {
            return nil
        }
        return ret
    }
}

public struct BitcoinSegwitAddress: Address {
    // WitnessProgram.encoded
    public var data: Data
    public var hrp: String = Slip.bitcoin.hrp

    public static func == (lhs: BitcoinSegwitAddress, rhs: BitcoinSegwitAddress) -> Bool {
        return lhs.hrp == rhs.hrp &&
                lhs.data == rhs.data
    }

    public static func isValid(data: Data) -> Bool {
        return data.count == 33 && data[0] == 0x00
    }

    public static func isValid(string: String) -> Bool {
        var hrp: NSString?
        guard Crypto.bech32Decode(string, hrp: &hrp) != nil,
            let readable = hrp as String?,
            BitcoinSegwitAddress.validate(hrp: readable as String) else {
                return false
        }
        return true
    }

    public static func validate(hrp: String) -> Bool {
        return hrp == Slip.bitcoin.hrp || hrp == Slip.bitcoin.hrpTestnet
    }

    public init?(string: String) {
        var hrp: NSString?
        guard let data = Crypto.bech32Decode(string, hrp: &hrp),
            let readable = hrp as String?,
            BitcoinSegwitAddress.validate(hrp: readable as String) else {
            return nil
        }
        self.hrp = readable
        self.data = data
    }

    public init?(data: Data) {
        guard BitcoinSegwitAddress.isValid(data: data) else {
            return nil
        }
        self.data = data
    }

    public var description: String {
        return Crypto.bech32Encode(data, hrp: hrp)
    }
}
