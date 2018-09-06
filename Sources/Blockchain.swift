// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

/// Blockchain represents what is unique about every blockchain.
open class Blockchain: Hashable {
    /// Coin type for Level 2 of BIP44.
    ///
    /// - SeeAlso: https://github.com/satoshilabs/slips/blob/master/slip-0044.md
    open var coinType: Slip {
        fatalError("Use a specific Blockchain subclass")
    }

    public init() {}

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
}

public extension Blockchain {
    func derivationPath(at index: Int) -> DerivationPath {
        return DerivationPath(purpose: 44, coinType: self.coinType.rawValue, account: 0, change: 0, address: index)
    }
}
