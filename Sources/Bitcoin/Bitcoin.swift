// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

/// Bitcoin blockchain.
///
/// Bitcoin-based blockchains should inherit from this class.
open class Bitcoin: Blockchain {
    /// SLIP-044 coin type.
    override open var coinType: SLIP.CoinType {
        return .bitcoin
    }

    override open var xpubVersion: SLIP.HDVersion? {
        switch self.coinPurpose {
        case .bip44:
            return SLIP.HDVersion.xpub
        case .bip49:
            return SLIP.HDVersion.ypub
        case .bip84:
            return SLIP.HDVersion.zpub
        }
    }

    override open var xprvVersion: SLIP.HDVersion? {
        switch self.coinPurpose {
        case .bip44:
            return SLIP.HDVersion.xprv
        case .bip49:
            return SLIP.HDVersion.yprv
        case .bip84:
            return SLIP.HDVersion.zprv
        }
    }

    /// Public key hash address prefix.
    open var p2pkhPrefix: UInt8 {
        return 0x00
    }

    /// Private key prefix.
    open var privateKeyPrefix: UInt8 {
        return 0x80
    }

    /// Pay to script hash (P2SH) address prefix.
    open var p2shPrefix: UInt8 {
        return 0x05
    }

    open var hrp: SLIP.HRP {
        return .bitcoin
    }

    override open func address(for publicKey: PublicKey) -> Address {
        switch coinPurpose {
        case .bip44:
            return publicKey.legacyBitcoinAddress(prefix: p2pkhPrefix)
        case .bip49:
            return publicKey.compatibleBitcoinAddress(prefix: p2shPrefix)
        case .bip84:
            return publicKey.compressed.bech32Address(hrp: hrp)
        }
    }

    override open func address(string: String) -> Address? {
        if let bech32Address = BitcoinBech32Address(string: string) {
            return bech32Address
        } else {
            return BitcoinAddress(string: string)
        }
    }

    override open func address(data: Data) -> Address? {
        if let bech32Address = BitcoinBech32Address(data: data) {
            return bech32Address
        } else {
            return BitcoinAddress(data: data)
        }
    }

    override public init(purpose: Purpose = .bip84) {
        super.init(purpose: purpose)
    }

    open func compatibleAddress(for publicKey: PublicKey) -> Address {
        return publicKey.compressed.compatibleBitcoinAddress(prefix: p2shPrefix)
    }

    open func compatibleAddress(string: String) -> Address? {
        return BitcoinAddress(string: string)
    }

    open func compatibleAddress(data: Data) -> Address? {
        return BitcoinAddress(data: data)
    }

    open func legacyAddress(for publicKey: PublicKey) -> Address {
        return publicKey.compressed.legacyBitcoinAddress(prefix: p2pkhPrefix)
    }

    open func legacyAddress(string: String) -> Address? {
        return BitcoinAddress(string: string)
    }

    open func legacyAddress(data: Data) -> Address? {
        return BitcoinAddress(data: data)
    }
}

public final class Dash: Bitcoin {
    override public var coinType: SLIP.CoinType {
        return .dash
    }

    override public var p2shPrefix: UInt8 {
        return 0x4C
    }

    override public init(purpose: Purpose = .bip44) {
        super.init(purpose: purpose)
    }
}
