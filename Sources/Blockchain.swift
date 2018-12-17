// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import TrezorCrypto

/// Blockchain represents what is unique about every blockchain.
open class Blockchain: Hashable {
    /// Coin type for Level 2 of BIP44.
    ///
    /// - SeeAlso: https://github.com/satoshilabs/slips/blob/master/slip-0044.md
    open var coinType: SLIP.CoinType {
        fatalError("Use a specific Blockchain subclass")
    }

    open var coinPurpose: Purpose

    open var xpubVersion: SLIP.HDVersion? {
        return nil
    }

    open var xprvVersion: SLIP.HDVersion? {
        return nil
    }

    public init(purpose: Purpose = .bip44) {
        self.coinPurpose = purpose
    }

    /// Returns the address associated with a public key.
    open func address(for publicKey: PublicKey) -> Address {
        fatalError("Use a specific Blockchain subclass")
    }

    /// Returns the address given its string representation.
    open func address(string: String) -> Address? {
        fatalError("Use a specific Blockchain subclass")
    }

    /// Returns the address given its raw representation.
    open func address(data: Data) -> Address? {
        fatalError("Use a specific Blockchain subclass")
    }

    // MARK: Hashable

    public static func == (lhs: Blockchain, rhs: Blockchain) -> Bool {
        return lhs.coinType == rhs.coinType
    }

    public var hashValue: Int {
        return coinType.hashValue
    }

    public func derivationPath(account: Int = 0, change: Int = 0, at index: Int) -> DerivationPath {
        return DerivationPath(purpose: coinPurpose.rawValue, coinType: coinType.rawValue, account: account, change: change, address: index)
    }
}

public extension Blockchain {
    func derive(from extendedPubkey: String, at path: DerivationPath) -> Address? {
        guard let xpubV = xpubVersion,
            let xprvV = xprvVersion else {
            return nil
        }

        var node = HDNode()
        var fingerprint: UInt32 = 0

        hdnode_deserialize(extendedPubkey, xpubV.rawValue, xprvV.rawValue, "secp256k1", &node, &fingerprint)
        hdnode_public_ckd(&node, UInt32(path.change))
        hdnode_public_ckd(&node, UInt32(path.address))
        hdnode_fill_public_key(&node)

        var data = Data()
        withUnsafeBytes(of: &node.public_key) {
            data.append($0.bindMemory(to: UInt8.self))
        }
        return self.address(for: PublicKey(data: data)!)
    }
}
