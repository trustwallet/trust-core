// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public typealias LitecoinAddress = BitcoinAddress
public typealias LitecoinBech32Address = BitcoinSegwitAddress

public final class Litecoin: Bitcoin {
    override public var coinType: SLIP.CoinType {
        return .litecoin
    }

    override public var privateKeyPrefix: UInt8 {
        return 0xB0
    }

    override public var p2pkhPrefix: UInt8 {
        return 0x30
    }

    override public var p2shPrefix: UInt8 {
        return 0x32
    }

    override public var hrp: SLIP.HRP {
        return .litecoin
    }
}
