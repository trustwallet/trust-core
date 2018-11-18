// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit

public enum TronContractType {
    case transferContract(from: Address, to: Address, amount: Int64)
    case transferAssetContract(from: Address, to: Address, amount: Int64, assetName: String)
}

extension TronContractType {
    public func transferContract(from: Address, to: Address, amount: Int64) -> TronContractType {
       return .transferContract(from: from, to: to, amount: amount)
    }
    public func transferAssetContract(from: Address, to: Address, amount: Int64, assetName: String) -> TronContractType {
        return .transferAssetContract(from: from, to: to, amount: amount, assetName: assetName)
    }
}
