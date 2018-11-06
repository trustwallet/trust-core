// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

//
//  PrivateKey+Wif.swift
//  CEOasisWallet
//
//  Created by haiqingxu on 2018/10/22.
//  Copyright © 2018年 (徐海青). All rights reserved.
//

import Foundation
import ObjectiveC

/// Creates a `PrivateKey` from a Bitcoin WIF (wallet import format) string.
var PrivateKey_keySuffix = 1000_000_000
var PrivateKey_keyPrefix = 1000_000_001


//    No suffix    P2PKH_UNCOMPRESSED    No    Uncompressed legacy public key. Unknown public key format
//    0x01    P2PKH_COMPRESSED    Yes    Compressed legacy public key. Unknown public key format
//    0x10    P2PKH    Yes    Compressed legacy public key. Legacy public key format (1...)
//    0x11    P2WPKH    Yes    Bech32 format (native Segwit)
//    0x12    P2WPKH_P2SH    Yes    Segwit nested in BIP16 P2SH (3...)

//    When a wallet imports a private key, it will have two outcomes:
//
//    the key is using one of the legacy types, in which case all types must be accounted for
//    the key is using one of the extended types, in which case the wallet need only track the specific corresponding address
//    Note: the difference between `0x01` and `0x10` is that the former can correspond to any of the types above, whereas the latter *only* corresponds to a P2PKH (legacy non-segwit).
// https://github.com/bitcoin/bips/blob/master/bip-0178.mediawiki

extension PrivateKey {
    
    public enum KeySuffix: UInt8 {
        //Compressed legacy public key. Unknown public key format
        case P2PKH_COMPRESSED = 0x01
        
        //Compressed legacy public key. Legacy public key format (1...)
        case P2PKH = 0x10
        
        //Bech32 format (native Segwit)
        case P2WPKH = 0x11
        
        //Segwit nested in BIP16 P2SH (3...)
        case P2WPKH_P2SH = 0x12
    }
    
    public enum KeyPrefix: UInt8 {
        case main = 0x80
        case test = 0xEF
    }
    
    var keySuffix: KeySuffix? {
        get {
            guard let suffix = objc_getAssociatedObject(self, &PrivateKey_keySuffix) as? UInt8 else {
                return nil
            }
            return KeySuffix.init(rawValue:suffix)
        }
        
        set {
            if let suffix = newValue {
                objc_setAssociatedObject(self, &PrivateKey_keySuffix, suffix.rawValue, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }
    
    var keyPrefix: KeyPrefix? {
        get {
            guard let prefix = objc_getAssociatedObject(self, &PrivateKey_keyPrefix) as? UInt8 else {
                return nil
            }
            return KeyPrefix.init(rawValue:prefix)
        }
        
        set {
            if let prefix = newValue {
                objc_setAssociatedObject(self, &PrivateKey_keyPrefix, prefix.rawValue, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }
    
    /// Creates a `PrivateKey` from a Bitcoin WIF (wallet import format) string.
    public convenience init?(wif: String) {
        guard let decoded = Crypto.base58Decode(wif) else {
            return nil
        }
        
        let prefixs = [KeyPrefix.main.rawValue,
                       KeyPrefix.test.rawValue]
        let suffixs = [KeySuffix.P2PKH_COMPRESSED.rawValue,
                       KeySuffix.P2PKH.rawValue,
                       KeySuffix.P2WPKH.rawValue,
                       KeySuffix.P2WPKH_P2SH.rawValue]
        
        if !prefixs.contains(decoded[0]) || !suffixs.contains(decoded.last!) {
            return nil
        }
        
        self.init(data: Data(decoded[1 ..< 33]))
        self.keyPrefix = KeyPrefix(rawValue: decoded[0])
        self.keySuffix = KeySuffix(rawValue: decoded.last!)
    }
    
    public var wif: String {
        return wif(prefix: keyPrefix ?? .main, suffix: keySuffix ?? .P2PKH_COMPRESSED)
    }
    
    public func wif(prefix : KeyPrefix, suffix : KeySuffix) -> String {
        let extentedData = Data(bytes: [prefix.rawValue]) + self.data + Data(bytes: [suffix.rawValue])
        return Crypto.base58Encode(extentedData)
    }
    
}
