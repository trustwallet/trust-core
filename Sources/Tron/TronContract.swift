// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit
import SwiftProtobuf

public struct TronContract {

    private let type: TronContractType

    public init(type: TronContractType) {
        self.type = type
    }

    public func contract() throws -> Protocol_Transaction.Contract {
        var contract = Protocol_Transaction.Contract()
        switch type {
        case .transferContract(let from, let to,let amount):
            var transferContract = Protocol_TransferContract()
            transferContract.ownerAddress = Crypto.base58Decode(from.description)!
            transferContract.toAddress = Crypto.base58Decode(to.description)!
            transferContract.amount = amount
            contract.type = .transferContract
            contract.parameter = try Google_Protobuf_Any.init(message: transferContract)
        case .transferAssetContract(let from, let to, let amount, let assetName):
            var transferAssetContract = Protocol_TransferAssetContract()
            transferAssetContract.ownerAddress = Crypto.base58Decode(from.description)!
            transferAssetContract.toAddress = Crypto.base58Decode(to.description)!
            transferAssetContract.assetName = Data(assetName.utf8)
            transferAssetContract.amount = amount
            contract.type = .transferAssetContract
            contract.parameter = try Google_Protobuf_Any.init(message: transferAssetContract)
        }
        return contract
    }
}
