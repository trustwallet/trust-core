// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit

enum TronTransactionError: LocalizedError {
    case transactionCreationError
    case blockHeaderRawData
    case blockHeaderHeight
}

public struct TronTransaction {
    
    private let tronContract: TronContract
    private let tronBlock: TronBlock
    private let timestamp: Date
    
    public init(
        tronContract: TronContract,
        tronBlock: TronBlock,
        timestamp: Date = Date()
    ) {
        self.tronContract = tronContract
        self.tronBlock = tronBlock
        self.timestamp = timestamp
    }
    
    public func transaction() throws -> Protocol_Transaction {
        var transaction = Protocol_Transaction()
        do {
            let contract = try tronContract.contract()
            transaction.rawData.contract = [contract]
            transaction.rawData.timestamp = Int64(timestamp.timeIntervalSince1970 * 1000)
            transaction.rawData.expiration = tronBlock.blockHeader.rawData.timestamp + 10 * 60 * 60 * 1000
            transaction = try setBlockReference(for: transaction)
            return transaction
        } catch {
            throw TronTransactionError.transactionCreationError
        }
    }
    
    private func setBlockReference(for transaction: Protocol_Transaction) throws -> Protocol_Transaction  {
        var transaction = transaction
        let blockHeight = tronBlock.blockHeader.rawData.number
        let blockHash = try getBlockHash()
        var refBlockNum = Data()
        blockHeight.encode(into: &refBlockNum)
 
        guard blockHash.count >= 16 else {
            throw TronTransactionError.blockHeaderRawData
        }

        transaction.rawData.refBlockHash = blockHash[7...15]
        
        guard refBlockNum.count >= 8 else {
            throw TronTransactionError.blockHeaderHeight
        }

        transaction.rawData.refBlockBytes = refBlockNum[5...7]
        
        return transaction
    }
    
    private func getBlockHash() throws -> Data {
        let data = try tronBlock.blockHeader.rawData.serializedData()
        return Crypto.sha256(data)
    }
}
