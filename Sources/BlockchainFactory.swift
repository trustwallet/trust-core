// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

/// Creates a blockchain for a specific SLIP-0044 coin type.
public func blockchain(coin: SLIP.CoinType) -> Blockchain {
    switch coin {
    case .bitcoin:
        return Bitcoin()
    case .litecoin:
        return Litecoin()
    case .ethereum:
        return Ethereum()
    case .ethereumClassic:
        return EthereumClassic()
    case .go:
        return Go()
    case .thunderToken:
        return ThunderToken()
    case .poa:
        return POA()
    case .tron:
        return Tron()
    case .vechain:
        return Vechain()
    case .callisto:
        return Callisto()
    case .wanchain:
        return Wanchain()
    case .dash:
        return Dash()
    case .icon:
        return Icon()
    }
}
