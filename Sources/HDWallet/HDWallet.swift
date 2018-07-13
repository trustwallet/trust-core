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

extension Blockchain {
    public var coinType: Int {
        switch self {
        case .bitcoin: return 0
        case .ethereum: return 60
        case .ethereumKovan, .ethereumRinkeby, .ethereumRopsten, .ethereumSokol: return 60
        case .poa: return 178
        case .ethereumClassic: return 61
        case .callisto: return 820
        case .gochain: return 6060
        }
    }

    public func derivationPath(at index: Int) -> DerivationPath {
        switch self {
        case .bitcoin:
            return DerivationPath(purpose: 44, coinType: coinType, account: 0, change: 0, address: index)
        case .ethereum,
             .poa,
             .ethereumClassic,
             .callisto,
             .gochain,
             .ethereumKovan,
             .ethereumRinkeby,
             .ethereumRopsten,
             .ethereumSokol:
            return DerivationPath(purpose: 44, coinType: coinType, account: 0, change: 0, address: index)
        }
    }
}
