// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit
import Foundation

enum TronTransactionError: Error {
    case blockHeaderHeight
    case blockHeaderRawData
}

struct TronTransaction {
    
    typealias Block = Protocol_Block
    let tronTransactionContract: TronTransactionContract
    
    func transaction(with latestBlock: Block) throws -> Protocol_Transaction {
        
        let contract = try tronTransactionContract.contract()
        let blockHeader = latestBlock.blockHeader
        
        var blockHeaderHeightBytesArray = Data()
        blockHeader.rawData.number.encode(into: &blockHeaderHeightBytesArray)
        guard blockHeaderHeightBytesArray.count > 8 else {
            throw TronTransactionError.blockHeaderHeight
        }
        let refBlockNum = blockHeaderHeightBytesArray[6...8]
        
        let blockHeaderRawDataByteArray = try blockHeader.rawData.serializedData()
        let blockHeaderHash = Crypto.sha256(blockHeaderRawDataByteArray)
        guard blockHeaderHash.count > 16 else {
            throw TronTransactionError.blockHeaderRawData
        }
        let blockHash = blockHeaderHash[8...16]
        
        let rawData = TronTransactionRawDataBuilder()
            .contract(contract)
            .timestamp(Date().currentTimeMilliseconds)
            .expiration(blockHeader.rawData.timestamp + 10 * 60 * 60 * 1000)
            .blockBytes(refBlockNum)
            .blockHash(blockHash)
            .build()
      
        var transaction = Protocol_Transaction()
        transaction.rawData = rawData
    
        return transaction
    }
}
