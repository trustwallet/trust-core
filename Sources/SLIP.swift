// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct SLIP {
    /// Coin type for Level 2 of BIP44.
    ///
    /// - SeeAlso: https://github.com/satoshilabs/slips/blob/master/slip-0044.md
    public enum CoinType: Int {
        case bitcoin = 0
        case litecoin = 2
        case dash = 5
        case ethereum = 60
        case ethereumClassic = 61
        case thunderToken = 1001
        case go = 6060
        case poa = 178
        case tron = 195
        case vechain = 818
        case callisto = 820
        case wanchain = 5718350
        case icon = 74
        case eos = 194
    }

    ///  Registered HD version bytes
    ///
    /// - SeeAlso: https://github.com/satoshilabs/slips/blob/master/slip-0132.md

    public enum HDVersion: UInt32 {
        // Bitcoin
        case xpub = 0x0488b21e
        case xprv = 0x0488ade4
        case ypub = 0x049d7cb2
        case yprv = 0x049d7878
        case zpub = 0x04b24746
        case zprv = 0x04b2430c
        // Litecoin
    }

    ///  Registered human-readable parts for BIP-0173
    ///
    /// - SeeAlso: https://github.com/satoshilabs/slips/blob/master/slip-0173.md
    public enum HRP: String {
        case bitcoin = "bc"
        case litecoin = "ltc"
    }
}
