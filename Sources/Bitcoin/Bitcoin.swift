// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public enum Bitcoin {
    public static let privateKeySize = 32
    public static let addressSize = 20

    public enum MainNet {
        public static let pubKeyHash: UInt8 = 0x00
        public static let privateKey: UInt8 = 0x80
        public static let scriptHash: UInt8 = 0x05
    }

    public enum TestNet {
        public static let pubKeyHash: UInt8 = 0x6f
        public static let privateKey: UInt8 = 0xef
        public static let scriptHash: UInt8 = 0xc
    }
}
