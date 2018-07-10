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

    /// Derivation path.
    public var path: String

    /// Initializes a wallet from a mnemonic string and a passphrase.
    public init(mnemonic: String, passphrase: String = "", path: String) {
        seed = Crypto.deriveSeed(mnemonic: mnemonic, passphrase: passphrase)
        self.mnemonic = mnemonic
        self.passphrase = ""
        self.path = path
    }

    private func getDerivationPath(for index: Int) -> DerivationPath {
        guard let path = DerivationPath(path.replacingOccurrences(of: "x", with: String(index))) else {
            preconditionFailure("Invalid derivation path string")
        }
        return path
    }

    private func getNode(for derivationPath: DerivationPath) -> HDNode {
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

    /// Generates the key at the specified derivation path index.
    public func getKey(at index: Int) -> PrivateKey {
        var node = getNode(for: getDerivationPath(for: index))
        let data = Data(bytes: withUnsafeBytes(of: &node.private_key) { ptr in
            return ptr.map({ $0 })
        })
        return PrivateKey(data: data)!
    }
}

extension Blockchain {
    public var defaultDerivationPath: String {
        switch self {
        case .bitcoin:
            return "m/44'/0'/0'/0/x"
        case .ethereum:
            return "m/44'/60'/0'/0/x"
        }
    }
}
