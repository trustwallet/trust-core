// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public extension PublicKey {
    /// Icon address.
    public var iconAddress: IconAddress {
        var hash: Data
        if (data.count) > 64 {
            hash = data.subdata(in: 1..<65)
            hash = Crypto.sha3_256(hash)
        } else {
            hash = Crypto.sha3_256(data)
        }
        return IconAddress(data: hash.suffix(IconAddress.size))!
    }
}
