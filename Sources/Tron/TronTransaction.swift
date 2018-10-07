// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit

public struct TronTransaction {
    
    private var transaction: Protocol_Transaction
    
    var getSignature: Data? {
        return transaction.signature.first
    }
    
    init(data: Data) {
        transaction = try! Protocol_Transaction(jsonUTF8Data: data)
    }
    
    /// Signs this transaction by filling in the signature value.
    ///
    /// - Parameters:
    ///   - key: private key to use for signing the hash
    mutating func sign(key: Data) {
        transaction.rawData.timestamp = Date().milliseconds
        transaction.sign(privateKey: key)
    }
}
