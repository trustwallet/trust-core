// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

extension TronTransaction {
    public func hash() -> Data {
        //TODO: should hash the entire rawData instead of just rawData.data
        return Crypto.sha256(self.rawData.data)
    }

    public mutating func sign(privateKey: Data) -> Data {
        let signature = Crypto.sign(hash: self.hash(), privateKey: privateKey)
        self.addSignature(signature)
        return signature
    }
}
