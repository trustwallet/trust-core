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

    override public var privateKeyPrefix: UInt8 {
        return 0xCC
    }

    public override var p2pkhPrefix: UInt8 {
        return 0x4C
    }

    override public init(purpose: Purpose = .bip44) {
        super.init(purpose: purpose)
    }

    public override func address(for publicKey: PublicKey) -> Address {
        return publicKey.compressed.legacyBitcoinAddress(prefix: p2pkhPrefix)
    }
}
