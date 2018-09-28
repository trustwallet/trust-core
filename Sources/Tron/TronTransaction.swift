// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit
import Foundation

struct TronTransaction {
    
    typealias Block = Protocol_Block
    let tronTransactionContract: TronTransactionContract
    
    func transaction(with latestBlock: Block) throws -> Protocol_Transaction {
        
        let contract = try tronTransactionContract.contract()
        let blockHeader = latestBlock.blockHeader

        let rawData = TronTransactionRawDataBuilder()
            .contract(contract)
            .timestamp(Date().currentTimeMilliseconds)
            .expiration(blockHeader.rawData.timestamp + 10 * 60 * 60 * 1000)
            .build()
        
        var transaction = Protocol_Transaction()
        transaction.rawData = rawData
        
        return transaction
    }
} 
