// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit
import Foundation

struct TronSigner {

    typealias TronTransaction = Protocol_Transaction
    
    var transaction: TronTransaction
    
    /// Signs this transaction by filling in the signature value.
    ///
    /// - Parameters:
    ///   - key: private key to use for signing the hash
    public mutating func sign(key: Data) {
        transaction.rawData.timestamp = Date().milliseconds
        transaction.sign(privateKey: key)
    }
}
