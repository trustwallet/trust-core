// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct BitcoinCashAddress: Address, Equatable {

    /// Version bytes
    ///
    /// https://github.com/bitcoincashorg/bitcoincash.org/blob/master/spec/cashaddr.md
    public static let p2khVersion: UInt8 = 0x00
    public static let p2shVersion: UInt8 = 0x08

    public var data: Data
    public let hrp: String

    public static func == (lhs: BitcoinCashAddress, rhs: BitcoinCashAddress) -> Bool {
        return lhs.data == rhs.data && lhs.hrp == rhs.hrp
    }

    public static func isValid(data: Data) -> Bool {
        // type bytes
        return data.count == 34 && (data[0] == 0x00 || data[0] == 0x01)
    }

    public static func isValid(string: String) -> Bool {
        guard let (data, _) = BitcoinCashAddress.cashAddrDecode(string: string) else {
            return false
        }
        return BitcoinCashAddress.isValid(data: data)
    }

    public static func validate(hrp: String) -> Bool {
        return SLIP.HRP.bitcoincash.rawValue == hrp || SLIP.HRP.bitcoincashTest.rawValue == hrp
    }

    public static func cashAddrDecode(string: String) -> (Data, String)? {
        let value: String = {
            if string.lowercased().hasPrefix(SLIP.HRP.bitcoincash.rawValue) {
                return string.lowercased()
            }
            return [SLIP.HRP.bitcoincash.rawValue, string.lowercased()].joined(separator: ":")
        }()
        var hrp: NSString?
        guard let data = Crypto.cashAddrDecode(value, hrp: &hrp),
            let readable = hrp as String?,
            BitcoinCashAddress.validate(hrp: readable as String) else {
                return nil
        }
        return (data, readable)
    }

    public init?(string: String) {
        guard let (data, hrp) = BitcoinCashAddress.cashAddrDecode(string: string) else {
            return nil
        }
        self.data = data
        self.hrp = hrp
    }

    public init?(data: Data) {
        guard BitcoinCashAddress.isValid(data: data) else {
            return nil
        }
        self.data = data
        self.hrp = SLIP.HRP.bitcoincash.rawValue
    }

    public init?(data: Data, hrp: String) {
        guard BitcoinCashAddress.isValid(data: data) else {
            return nil
        }
        guard BitcoinCashAddress.validate(hrp: hrp) else {
            return nil
        }
        self.data = data
        self.hrp = hrp
    }

    public var description: String {
        let prefix = hrp + ":"
        let address = Crypto.cashAddrEncode(data, hrp: hrp)
        guard address.hasPrefix(prefix) else {
            return address
        }
        return String(address.dropFirst(prefix.count))
    }

    public func toBitcoinAddress() -> BitcoinAddress {
        let bc = BitcoinCash()
        let data = convertBits(self.data, from: 5, to: 8, pad: false)!
        let prefix = data[0] == BitcoinCashAddress.p2khVersion ? bc.p2pkhPrefix : bc.p2shPrefix
        return BitcoinAddress(data: Data([prefix]) + data.dropFirst())!
    }
}
