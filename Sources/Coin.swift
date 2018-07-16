// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

/// Supported coins.
/// Index based on https://github.com/satoshilabs/slips/blob/master/slip-0044.md
public enum Coin: Int {
    case bitcoin = 0
    case ethereum = 60
    case ethereumClassic = 61
    case poa = 172
    case callisto = 820
    case gochain = 6060
}
