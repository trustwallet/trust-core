// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public extension PublicKey {
    /// Returns the public key address with the given prefix.
    public func legacyBitcoinAddress(prefix: UInt8) -> BitcoinAddress {
        let hash = Data([prefix]) + bitcoinKeyHash
        return BitcoinAddress(data: hash)!
    }

    public func compatibleBitcoinAddress(prefix: UInt8) -> BitcoinAddress {
        let witnessVersion = Data(bytes: [0x00, 0x14])
        let redeemScript = Crypto.sha256ripemd160(witnessVersion + bitcoinKeyHash)
        let address = Crypto.base58Encode([prefix] + redeemScript)
        return BitcoinAddress(string: address)!
    }

    public func bech32Address(hrp: SLIP.HRP = .bitcoin) -> BitcoinBech32Address {
        let witness = WitnessProgram(version: 0x00, program: bitcoinKeyHash)
        let address = BitcoinBech32Address(data: witness.bech32Data!, hrp: hrp.rawValue)!
        return address
    }

    /// Returns the public key hash.
    public var bitcoinKeyHash: Data {
        return Crypto.sha256ripemd160(data)
    }
}
