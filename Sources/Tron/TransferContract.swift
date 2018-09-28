// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit
import SwiftProtobuf

struct TransferContract: TronTransactionContract {
    
    private let ownerAddress: Data
    private let toAddress: Data
    private let amount: Int64
    
    init(ownerAddress: Data, toAddress: Data, amount: Int64) {
        self.ownerAddress = ownerAddress
        self.toAddress = toAddress
        self.amount = amount
    }
    
    func contract() throws -> TronTransactionContract.Contract {
        var transferContract = Contract()
        var transfer = Protocol_TransferContract()
        
        transfer.ownerAddress = ownerAddress
        transfer.toAddress = toAddress
        transfer.amount = amount
        
        let parameter = try Google_Protobuf_Any.init(message: transferContract)
        transferContract.type = Contract.ContractType.transferContract
        transferContract.parameter = parameter
        
        return transferContract
    }
}
