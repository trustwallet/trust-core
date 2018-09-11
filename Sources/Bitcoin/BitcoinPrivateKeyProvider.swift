// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public protocol BitcoinPrivateKeyProvider {
    /// Should return the private key for a public key hash or a script hash
    func key(forPublicKeyHash: Data) -> PrivateKey?

    /// Should return the private key for a public key hash or a script hash
    func key(forScriptHash: Data) -> PrivateKey?
}

extension BitcoinPrivateKeyProvider {
    func key(forPublicKey pubkey: PublicKey) -> PrivateKey? {
        return key(forPublicKeyHash: pubkey.bitcoinKeyHash)
    }
}

public final class BitcoinDefaultPrivateKeyProvider: BitcoinPrivateKeyProvider {
    public var keys: [PrivateKey]
    public var keysByScriptHash: [Data: PrivateKey]

    public init(keys: [PrivateKey], keysByScriptHash: [Data: PrivateKey] = [:]) {
        self.keys = keys
        self.keysByScriptHash = keysByScriptHash
    }

    public func key(forPublicKeyHash hash: Data) -> PrivateKey? {
        return keys.first { key in
            let publicKey = key.publicKey(compressed: true)
            return publicKey.bitcoinKeyHash == hash
        }
    }

    public func key(forScriptHash hash: Data) -> PrivateKey? {
        return keysByScriptHash[hash]
    }
}
