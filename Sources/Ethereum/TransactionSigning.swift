// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import BigInt

protocol Signer {
    func values(signature: Data) -> (r: BigInt, s: BigInt, v: BigInt)
}

struct EIP155Signer: Signer {
    let chainID: BigInt

    func hash(transaction: EthereumTransaction) -> Data {
        return rlpHash([
            transaction.nonce,
            transaction.gasPrice,
            transaction.gasLimit,
            transaction.to?.data ?? Data(),
            transaction.amount,
            transaction.payload ?? Data(),
            chainID, 0, 0,
        ] as [Any])!
    }

    func values(signature: Data) -> (r: BigInt, s: BigInt, v: BigInt) {
        return SignatureSigner.values(chainID: chainID, signature: signature)
    }
}

struct WanchainSigner: Signer {
    let chainID: BigInt

    func hash(transaction: WanchainTransaction) -> Data {
        return rlpHash([
            transaction.type,
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

struct SignatureSigner {
    static func values(chainID: BigInt, signature: Data) -> (r: BigInt, s: BigInt, v: BigInt) {
        let (r, s, v) = HomesteadSigner().values(signature: signature)
        let newV: BigInt
        if chainID != 0 {
            newV = BigInt(signature[64]) + 35 + chainID + chainID
        } else {
            newV = v
        }
        return (r, s, newV)
    }
}

struct HomesteadSigner: Signer {
    func values(signature: Data) -> (r: BigInt, s: BigInt, v: BigInt) {
        precondition(signature.count == 65, "Wrong size for signature")
        let r = BigInt(sign: .plus, magnitude: BigUInt(Data(signature[..<32])))
        let s = BigInt(sign: .plus, magnitude: BigUInt(Data(signature[32..<64])))
        let v = BigInt(sign: .plus, magnitude: BigUInt(Data(bytes: [signature[64] + 27])))
        return (r, s, v)
    }
}

func rlpHash(_ element: Any) -> Data? {
    guard let data = RLP.encode(element) else {
        return nil
    }
    return Crypto.hash(data)
}
