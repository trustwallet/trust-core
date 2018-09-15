// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest
import SwiftProtobuf

class TronTransactionTests: XCTestCase {
    func testTransactionSigning() {
        var rawData = TronTransaction.RawData()
        rawData.timestamp = 123
        rawData.refBlockNum = 456
        rawData.refBlockHash = "refBlockHash".data(using: .utf8) ?? Data()

        var transactionToBeSigned = TronTransaction(rawData: rawData)

        let hashHexString = transactionToBeSigned.hash().hexString
        let hashData = Data(hexString: hashHexString)!

        XCTAssertEqual(64, hashHexString.count)

        let privateKey = PrivateKey()
        let publicKey = privateKey.publicKey(compressed: true)

        XCTAssertFalse(transactionToBeSigned.hasSignature)

        let result = transactionToBeSigned.sign(privateKey: privateKey.data)

        XCTAssertEqual(result.count, 65)
        XCTAssertTrue(Crypto.verify(signature: result, message: hashData, publicKey: publicKey.data))
        XCTAssertTrue(transactionToBeSigned.hasSignature)
    }

    func testTransactionSigningWithRealData() {
        // https://api.tronscan.org/#/Transactions/findAll
        // https://tronscan.org/#/transaction/3d9fdb03efac1b2fa58cd92b7c283eb76a232cbc434790c8ca684255a7f212b6
        // GetTransactionById 3d9fdb03efac1b2fa58cd92b7c283eb76a232cbc434790c8ca684255a7f212b6
        /*
         raw_data {
             ref_block_bytes: "b238"
             ref_block_hash: "3b15cb7e4a1c8168"
             expiration: 1536926241000
             data: "Test%201.1"
             contract {
                 type: TransferContract
                 parameter {
                     type_url: "type.googleapis.com/protocol.TransferContract"
                     value: "0a1541469d067b0d0ab59ef5399cc9c9cf6ca2bc129a43121541699fefc95ac273a3b4188efc68fd4b26ca85ec5218e09143"
                 }
             }
         }
         signature: "e26f125d0e48e33efeb89efd616bfb7fb73e5a558f4ef8ac0094c3d7ad3a2796d5d8fc51fdaec40671bad3af21b21b4509961a8cf8b8f6b55239072d6956b40401"
         */

        let contract = TronTransactionContractBuiler()
            .type(.transferContract)
            .parameter()
            .build()

        let rawData = TronTransactionRawDataBuilder()
            .timestamp(0)
            .expiration(1536926241000)
            .blockBytes("b238".hexadecimal()!)
            .blockHash("3b15cb7e4a1c8168".hexadecimal()!)
            .contract(contract)
            .build()

        var transactionToBeSigned = TronTransaction(rawData: rawData)

        let hashHexString = transactionToBeSigned.hash().hexString
        let hashData = Data(hexString: hashHexString)!

        XCTAssertEqual(64, hashHexString.count)

        let privateKey = PrivateKey(data: Data(hexString: "70815E46680F0C131844B34C33EF0385B5C459820A8D091F97B646DB2396E37E")!)!
        let publicKey = privateKey.publicKey(compressed: true)
        let address = Tron().address(for: publicKey)

        XCTAssertEqual("TGQaQoCM7LprSH4TE4FemmZhEQMZMKvAGH", address.description)
        XCTAssertFalse(transactionToBeSigned.hasSignature)

        let result = transactionToBeSigned.sign(privateKey: privateKey.data)

        XCTAssertEqual("e26f125d0e48e33efeb89efd616bfb7fb73e5a558f4ef8ac0094c3d7ad3a2796d5d8fc51fdaec40671bad3af21b21b4509961a8cf8b8f6b55239072d6956b40401", result.hexString)
        XCTAssertEqual(result.count, 65)
        XCTAssertTrue(Crypto.verify(signature: result, message: hashData, publicKey: publicKey.data))
        XCTAssertTrue(transactionToBeSigned.hasSignature)
    }
}

/* Builders */
class TronTransactionRawDataBuilder {
    var rawData = TronTransaction.RawData()

    func blockHash(_ blockHash: Data) -> TronTransactionRawDataBuilder {
        rawData.refBlockHash = blockHash
        return self
    }

    func blockBytes(_ blockBytes: Data) -> TronTransactionRawDataBuilder {
        rawData.refBlockBytes = blockBytes
        return self
    }

    func blockNumber(_ blockNumber: Int64) -> TronTransactionRawDataBuilder {
        rawData.refBlockNum = blockNumber
        return self
    }

    func expiration(_ expiration: Int64) -> TronTransactionRawDataBuilder {
        rawData.expiration = expiration
        return self
    }

    func timestamp(_ timestamp: Int64) -> TronTransactionRawDataBuilder {
        rawData.timestamp = timestamp
        return self
    }

    func contract(_ contract: TronTransaction.Contract) -> TronTransactionRawDataBuilder {
        rawData.contract.append(contract)
        return self
    }

    func build() -> TronTransaction.RawData {
        return rawData
    }
}

class TronTransactionContractBuiler {
    var contract = TronTransaction.Contract()

    func type(_ type: TronTransaction.Contract.ContractType) -> TronTransactionContractBuiler {
        contract.type = type
        return self
    }

    func parameter() -> TronTransactionContractBuiler {
        var parameter = SwiftProtobuf.Google_Protobuf_Any()
        parameter.typeURL = "TransferContract"
        parameter.value = "0a1541469d067b0d0ab59ef5399cc9c9cf6ca2bc129a43121541699fefc95ac273a3b4188efc68fd4b26ca85ec5218e09143".hexadecimal()!
        return self
    }

    func build() -> TronTransaction.Contract {
        return contract
    }
}
