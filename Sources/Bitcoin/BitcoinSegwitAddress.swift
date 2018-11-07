// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct BitcoinSegwitAddress: Address, Equatable {
    // bech32 data
    public var data: Data

    public var hrp: SLIP.HRP

    public static func == (lhs: BitcoinSegwitAddress, rhs: BitcoinSegwitAddress) -> Bool {
        return lhs.data == rhs.data
    }

    public static func isValid(data: Data) -> Bool {
        return (data.count == 33 || data.count == 53) && data[0] == 0x00
    }

    public static func isValid(string: String) -> Bool {
        guard let (data, _) = BitcoinSegwitAddress.bech32Decode(string: string) else {
            return false
        }
        return BitcoinSegwitAddress.isValid(data: data)
    }

    public static func validate(hrp: String) -> Bool {
        return hrp == SLIP.HRP.bitcoin.rawValue || hrp == SLIP.HRP.bitcoinTestNet.rawValue
    }

    public static func bech32Decode(string: String) -> (Data,String)? {
        var hrp: NSString?
        guard let data = Crypto.bech32Decode(string, hrp: &hrp),
            let readable = hrp as String?,
            BitcoinSegwitAddress.validate(hrp: readable as String) else {
                return nil
        }
        return (data,readable as String)
    }

    public init?(string: String) {
        guard let (data, hrp) = BitcoinSegwitAddress.bech32Decode(string: string) else {
            return nil
        }
        self.data = data
        self.hrp = SLIP.HRP(rawValue: hrp)!
    }

    public init?(data: Data) {
        self.init(data: data, hrp: .bitcoin)
    }

    public init?(data: Data, hrp: SLIP.HRP) {
        guard BitcoinSegwitAddress.isValid(data: data) else {
            return nil
        }
        self.data = data
        self.hrp = hrp
    }

    public var description: String {
        return Crypto.bech32Encode(data, hrp: hrp.rawValue)
    }
}

public struct BitcoinTestNetSegwitAddress: Address, Equatable {
    // bech32 data
    public var data: Data

    public static func == (lhs: BitcoinTestNetSegwitAddress, rhs: BitcoinTestNetSegwitAddress) -> Bool {
        return lhs.data == rhs.data
    }

    public static func isValid(data: Data) -> Bool {
        return (data.count == 33 || data.count == 53) && data[0] == 0x00
    }

    public static func isValid(string: String) -> Bool {
        guard let data = BitcoinTestNetSegwitAddress.bech32Decode(string: string) else {
            return false
        }
        return BitcoinTestNetSegwitAddress.isValid(data: data)
    }

    public static func validate(hrp: String) -> Bool {
        return hrp == SLIP.HRP.bitcoinTestNet.rawValue
    }

    public static func bech32Decode(string: String) -> Data? {
        var hrp: NSString?
        guard let data = Crypto.bech32Decode(string, hrp: &hrp),
            let readable = hrp as String?,
            BitcoinTestNetSegwitAddress.validate(hrp: readable as String) else {
                return nil
        }
        return data
    }

    public init?(string: String) {
        guard let data = BitcoinTestNetSegwitAddress.bech32Decode(string: string) else {
            return nil
        }
        self.data = data
    }

    public init?(data: Data) {
        guard BitcoinTestNetSegwitAddress.isValid(data: data) else {
            return nil
        }
        self.data = data
    }

    public var description: String {
        return Crypto.bech32Encode(data, hrp: SLIP.HRP.bitcoinTestNet.rawValue)
    }
}
