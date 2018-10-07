// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit

public final class TronTransactionRawDataBuilder {
    private var rawData = Protocol_Transaction.raw()
    
    public func blockHash(_ blockHash: Data) -> TronTransactionRawDataBuilder {
        rawData.refBlockHash = blockHash
        return self
    }
    
    public func blockBytes(_ blockBytes: Data) -> TronTransactionRawDataBuilder {
        rawData.refBlockBytes = blockBytes
        return self
    }
    
    public func blockNumber(_ blockNumber: Int64) -> TronTransactionRawDataBuilder {
        rawData.refBlockNum = blockNumber
        return self
    }
    
    public func expiration(_ expiration: Int64) -> TronTransactionRawDataBuilder {
        rawData.expiration = expiration
        return self
    }
    
    public func timestamp(_ timestamp: Int64) -> TronTransactionRawDataBuilder {
        rawData.timestamp = timestamp
        return self
    }
    
    public func contract(_ contract: TronTransactionContract.Contract) -> TronTransactionRawDataBuilder {
        rawData.contract.append(contract)
        return self
    }
    
    public func data(_ data: Data) -> TronTransactionRawDataBuilder {
        rawData.data = data
        return self
    }
    
    public func build() -> Protocol_Transaction.raw {
        return rawData
    }
}
