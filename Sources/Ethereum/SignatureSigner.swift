// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import BigInt

struct SignatureSigner {
    static func values(chainID: BigInt, signature: Data) -> (r: BigInt, s: BigInt, v: BigInt) {
        let (r, s, v) = HomesteadSigner().values(signature: signature)
        let newV: BigInt
        if chainID != 0 {
            newV = BigInt(signature[64]) + 35 + chainID + chainID
        } else {
            newV = v
        }
        return (r, s, newV)
    }
}
