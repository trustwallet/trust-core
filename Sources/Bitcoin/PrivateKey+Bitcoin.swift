// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

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
        case p2pkh_compressed = 0x01

        //Compressed legacy public key. Legacy public key format (1...)
        case p2pkh = 0x10

        //Bech32 format (native Segwit)
        case p2wpkh = 0x11

        //Segwit nested in BIP16 P2SH (3...)
        case p2wpkh_p2sh = 0x12
    }

    public enum KeyPrefix: UInt8 {
        case main = 0x80
        case test = 0xEF
    }

    /// Creates a `PrivateKey` from a Bitcoin WIF (wallet import format) string.
    public convenience init?(wif: String) {
        guard let decoded = Crypto.base58Decode(wif) else {
            return nil
        }

        let prefixs = [KeyPrefix.main.rawValue,KeyPrefix.test.rawValue]
        let suffixs = [KeySuffix.p2pkh_compressed.rawValue,
                       KeySuffix.p2pkh.rawValue,
                       KeySuffix.p2wpkh.rawValue,
                       KeySuffix.p2wpkh_p2sh.rawValue]

        if !prefixs.contains(decoded[0]) || !suffixs.contains(decoded.last!) {
            return nil
        }

        self.init(data: Data(decoded[1 ..< 33]))
    }

    public var wif: String {
        return wif(prefix: .main, suffix: .p2pkh_compressed)
    }

    public func wif(prefix: KeyPrefix, suffix: KeySuffix) -> String {
        let extentedData = Data(bytes: [prefix.rawValue]) + self.data + Data(bytes: [suffix.rawValue])
        return Crypto.base58Encode(extentedData)
    }

}
