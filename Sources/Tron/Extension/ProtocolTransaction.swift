// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit

extension Protocol_Transaction {
    private var keccak256: Data {
        return Crypto.sha256(rawData.data)
    }
    
    mutating func sign(privateKey: Data) {
        let sign = Crypto.sign(hash: keccak256, privateKey: privateKey)
        signature.append(sign)
    }
}
