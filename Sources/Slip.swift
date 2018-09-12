// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

/// Coin type for Level 2 of BIP44.
///
/// - SeeAlso: https://github.com/satoshilabs/slips/blob/master/slip-0044.md

public enum Slip: Int {
    case bitcoin = 0
    case litecoin = 2
    case dash = 5
    case ethereum = 60
    case ethereumClassic = 61
    case go = 6060
    case poa = 178
    case tron = 195
    case vechain = 818
    case callisto = 820
    case wanchain = 5718350
}

extension Slip {
    public var compressed: Bool {
        switch self {
        case .ethereum,
             .ethereumClassic,
             .go,
             .poa,
             .vechain,
             .callisto,
             .wanchain:
            return false
        case .bitcoin,
             .dash,
             .litecoin,
             .tron:
            return true
        }
    }
}
