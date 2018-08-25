// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import BigInt

struct WanchainSigner: Signer {
    let chainID: BigInt

    func hash(transaction: WanchainTransaction) -> Data {
        return rlpHash([
            transaction.type.rawValue,
            transaction.transaction.nonce,
            transaction.transaction.gasPrice,
            transaction.transaction.gasLimit,
            transaction.transaction.to?.data ?? Data(),
            transaction.transaction.amount,
            transaction.transaction.payload ?? Data(),
            chainID, 0, 0,
        ] as [Any])!
    }

    func values(signature: Data) -> (r: BigInt, s: BigInt, v: BigInt) {
        return SignatureSigner.values(chainID: chainID, signature: signature)
    }
}
