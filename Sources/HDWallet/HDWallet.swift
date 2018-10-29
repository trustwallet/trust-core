// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import TrezorCrypto

/// A hierarchical deterministic wallet.
public class HDWallet {
    /// Wallet seed.
    public var seed: Data

    /// Mnemonic word list.
    public var mnemonic: String

    /// Mnemonic passphrase.
    public var passphrase: String

    /// Initializes a wallet from a mnemonic string and a passphrase.
    public init(mnemonic: String, passphrase: String = "") {
        seed = Crypto.deriveSeed(mnemonic: mnemonic, passphrase: passphrase)
        self.mnemonic = mnemonic
        self.passphrase = passphrase
    }

    deinit {
        seed.clear()
        mnemonic.clear()
    }

    /// Generates the key at the specified derivation path.
    public func getKey(at derivationPath: DerivationPath) -> PrivateKey {
        var node = getNode(at: derivationPath)
        let data = Data(bytes: withUnsafeBytes(of: &node.private_key) { ptr in
            return ptr.map({ $0 })
        })
        return PrivateKey(data: data)!
    }

    public func getExtendedPrivateKey(for purpose: Purpose) -> String {
        var node = getNode(for: purpose)
        let buffer = [Int8](repeating: 0, count: 128)
        let fingerprint = hdnode_fingerprint(&node)
        hdnode_private_ckd(&node, DerivationPath.Index(0, hardened: true).derivationIndex)
        hdnode_serialize_private(&node, fingerprint, purpose.xprvVersion, UnsafeMutablePointer<Int8>(mutating: buffer), 128)
        return String(cString: buffer)
    }

    public func getExtendedPubKey(for purpose: Purpose) -> String {
        var node = getNode(for: purpose)
        let buffer = [Int8](repeating: 0, count: 128)
        let fingerprint = hdnode_fingerprint(&node)
        hdnode_private_ckd(&node, DerivationPath.Index(0, hardened: true).derivationIndex)
        hdnode_fill_public_key(&node)
        hdnode_serialize_public(&node, fingerprint, purpose.xpubVersion, UnsafeMutablePointer<Int8>(mutating: buffer), 128)
        return String(cString: buffer)
    }

    private func getNode(for purpose: Purpose) -> HDNode {
        var node = HDNode()
        let count = Int32(seed.count)
        _ = seed.withUnsafeBytes { seed in
            hdnode_from_seed(seed, count, "secp256k1", &node)
        }

        let indices = [
            DerivationPath.Index(purpose.rawValue, hardened: true),
            DerivationPath.Index(0, hardened: true),
            ]

        for index in indices {
            hdnode_private_ckd(&node, index.derivationIndex)
        }
        return node
    }

    private func getNode(at derivationPath: DerivationPath) -> HDNode {
        var node = HDNode()
        let count = Int32(seed.count)
        _ = seed.withUnsafeBytes { seed in
            hdnode_from_seed(seed, count, "secp256k1", &node)
        }
        for index in derivationPath.indices {
            hdnode_private_ckd(&node, index.derivationIndex)
        }
        return node
    }
}
