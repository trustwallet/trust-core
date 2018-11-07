// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct WitnessProgram: Equatable {

    public let version: UInt8
    public let program: Data

    var bech32Data: Data? {
        guard valid else { return nil }
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
        //fix bugs: According to https://github.com/bitcoin/bips/blob/master/bip-0141.mediawiki
        if program.count < 2 || program.count > 40 {
            return false
        }
        if version == 0 && program.count != 20 && program.count != 32 {
            return false
        }
        return true
    }

    public static func from(bech32 address: String) -> WitnessProgram? {
        guard let (data, _) = BitcoinSegwitAddress.bech32Decode(string: address) else {
            return nil
        }
        return WitnessProgram.from(bech32: data)
    }

    public static func from(bech32 data: Data) -> WitnessProgram? {
        //Valid for main net and test net
        guard BitcoinSegwitAddress.isValid(data: data) else {
            return nil
        }
        let version = data[0]
        let program = convertBits(data[1...], from: 5, to: 8, pad: false)!
        return WitnessProgram(version: version, program: program)
    }
}

public func convertBits(_ data: Data, from: UInt32, to: UInt32, pad: Bool = true) -> Data? {
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
