// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit
import SwiftProtobuf

public struct TronContract {

    private let from: Address
    private let to: Address
    private let amount: Int64

    public init(
        from: Address,
        to: Address,
        amount: Int64
    ) {
        self.from = from
        self.to = to
        self.amount = amount
    }

    public func contract() throws -> Protocol_Transaction.Contract {
        var contract = Protocol_Transaction.Contract()
        var transferContract = Protocol_TransferContract()
        transferContract.ownerAddress = Crypto.base58Decode(from.description)!
        transferContract.toAddress = Crypto.base58Decode(to.description)!
        transferContract.amount = amount
        contract.type = .transferContract
        contract.parameter = try Google_Protobuf_Any.init(message: transferContract)
        return contract
    }
}
