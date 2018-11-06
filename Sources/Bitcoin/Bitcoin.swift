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
    open var privateKeyPrefix: UInt8 { return 0x80 }

    /// Pay to script hash (P2SH) address prefix.
    open var p2shPrefix: UInt8 {
        return 0x05
    }

    override open func address(for publicKey: PublicKey) -> Address {
        switch coinPurpose {
        case .bip44:
            return publicKey.legacyBitcoinAddress(prefix: p2pkhPrefix)
        case .bip49:
            return publicKey.compatibleBitcoinAddress(prefix: p2shPrefix)
        case .bip84:
            return publicKey.compressed.bitcoinBech32Address()
        }
    }

    override open func address(string: String) -> Address? {
        if let bech32Address = BitcoinSegwitAddress(string: string) {
            return bech32Address
        } else {
            return BitcoinAddress(string: string)
        }
    }

    override open func address(data: Data) -> Address? {
        if let bech32Address = BitcoinSegwitAddress(data: data) {
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

    open func legacyAddress(for publicKey: PublicKey, prefix: UInt8) -> Address {
        return publicKey.compressed.legacyBitcoinAddress(prefix: prefix)
    }

    open func legacyAddress(string: String) -> Address? {
        return BitcoinAddress(string: string)
    }

    open func legacyAddress(data: Data) -> Address? {
        return BitcoinAddress(data: data)
    }
    
    /// Address for multiple sig. P2SH Address
    public class func multiSigAddress(_ multi: ([PublicKey] , Int)) -> Address{
        let redeemScript = BitcoinScript.buildPayToMultiSigHash(multi)
        let redeemscriptHash = Crypto.sha256ripemd160(redeemscript.data)
        let address = Crypto.base58Encode([payToScriptHashAddressPrefix] + scirptHash)
        return BitcoinAddress(string: address)!
    }
    
    /// Address for P2WSH Address
    public class func multiP2WSHAddress(_ multi: ([PublicKey] , Int)) -> Address{
        let witnessScript = BitcoinScript.buildPayToMultiSigHash(multi)
        let program = Crypto.sha256(witnessScript.data)
        let witness = WitnessProgram(version: 0x00, program: scirptHash)
        let address = BitcoinSegwitAddress(data: witness.bech32Data!)!
        return address
    }
    
    /// Address for P2WSH-IN-P2SH Address
    public class func multiP2WSHNestedInP2SHAddress(_ multi: ([PublicKey] , Int)) -> Address{
        let witnessScript = BitcoinScript.buildPayToMultiSigHash(multi)
        let witnessScriptHash = Crypto.sha256(witnessScript.data)
        let redeemScript = BitcoinScript.buildPayToWitnessScriptHash(witnessScriptHash)
        let redeemScriptHash = Crypto.sha256ripemd160(redeemScript.data)
        let address = Crypto.base58Encode([payToScriptHashAddressPrefix] + redeemScriptHash)
        return BitcoinAddress(string: address)!
    }
}

public final class Litecoin: Bitcoin {
    override public var coinType: SLIP.CoinType {
        return .litecoin
    }

    override public var p2shPrefix: UInt8 {
        return 0x32
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

public final class BitcoinTestNet: Bitcoin {
    
    public override var coinType: SLIP.CoinType {
        return .bitcoinTestNet
    }
    
    open override var p2pkhPrefix: UInt8 {
        return 0x6F
    }
    
    public override var p2shPrefix: UInt8 {
        return 0xC4
    }
    
    open override func address(data: Data) -> Address? {
        if let bech32Address = BitcoinTestNetSegwitAddress(data: data) {
            return bech32Address
        } else {
            return BitcoinAddress(data: data)
        }
    }
    
    open override func address(string: String) -> Address? {
        if let bech32Address = BitcoinTestNetSegwitAddress(string: string) {
            return bech32Address
        } else {
            return BitcoinAddress(string: string)
        }
    }
    
    /// Address for P2WSH Address
    public override class func multiP2WSHAddress(_ multi: ([PublicKey] , Int)) -> Address {
        let multiScript = BitcoinScript.buildPayToMultiSigHash(multi)
        let reemdscript = multiScript.data
        let scirptHash = Crypto.sha256(reemdscript)
        let witness = WitnessProgram(version: 0x00, program: scirptHash)
        let address = BitcoinTestNetSegwitAddress(data: witness.bech32Data!)!
        return address
    }
    
}
