// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public final class Dash: Bitcoin {
    override public var coinType: SLIP.CoinType {
        return .dash
    }

    /// Private key prefix.
    ///
    /// - SeeAlso: https://dash-docs.github.io/en/developer-guide#wallet-import-format-wif
    override public var privateKeyPrefix: UInt8 {
        switch network {
        case .main:
            return 0xCC
        case .test:
            return 0xEF
        }
    }

    /// Public key hash address prefix.
    ///
    /// - SeeAlso: https://dash-docs.github.io/en/developer-reference#address-conversion
    public override var p2pkhPrefix: UInt8 {
        switch network {
        case .main:
            return 0x4C
        case .test:
            return 0x8c
        }
    }

    override public init(purpose: Purpose = .bip44) {
        super.init(purpose: purpose)
    }

    convenience public init(purpose: Purpose = .bip44, network: SLIP.Network) {
        self.init(purpose: purpose)
        self.network = network
    }

    public override func address(for publicKey: PublicKey) -> Address {
        return publicKey.compressed.legacyBitcoinAddress(prefix: p2pkhPrefix)
    }
}
