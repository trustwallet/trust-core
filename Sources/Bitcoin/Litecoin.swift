// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public enum Litecoin {
    public enum MainNet {
        /// Pay to script hash (P2SH) address prefix.
        public static let payToScriptHashAddressPrefix: UInt8 = 0x32
    }

    public enum TestNet {
        /// Pay to script hash (P2SH) address prefix.
        public static let payToScriptHashAddressPrefix: UInt8 = 0x0c
    }
}
