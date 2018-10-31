// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

extension PrivateKey {
    /// Creates a `PrivateKey` from a Bitcoin WIF (wallet import format) string.
    public convenience init?(wif: String) {
        guard let decoded = Crypto.base58Decode(wif) else {
            return nil
        }
        //if decoded[0] != 0x80 || decoded.last != 0x01 {
        //    return nil
        //}
        self.init(data: Data(decoded[1 ..< 33]))
    }
}
