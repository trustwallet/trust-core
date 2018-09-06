// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

/// Creates a blockchain for a specific SLIP-0044 coin type.
public func blockchain(coin: Int) -> Blockchain? {
    switch coin {
    case 0:
        return Bitcoin()
    case 2:
        return Litecoin()
    case 60:
        return Ethereum()
    case 61:
        return EthereumClassic()
    case 6060:
        return Go()
    case 178:
        return POA()
    case 195:
        return Tron()
    case 818:
        return Vechain()
    case 820:
        return Callisto()
    case 5718350:
        return Wanchain()
    default:
        return nil
    }
}
