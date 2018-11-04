// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

// See https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki
// See https://github.com/bitcoin/bips/blob/master/bip-0049.mediawiki
// See https://github.com/bitcoin/bips/blob/master/bip-0084.mediawiki

public enum Purpose: Int {
    case bip44 = 44
    case bip49 = 49 //Derivation scheme for P2WPKH-nested-in-P2SH
    case bip84 = 84 //Derivation scheme for P2WPKH
}
