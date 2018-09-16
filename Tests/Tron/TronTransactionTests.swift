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
        let privateKey = PrivateKey(data: Data(hexString: "70815e46680f0c131844b34c33ef0385b5c459820a8d091f97b646db2396e37e")!)!
        let publicKey = privateKey.publicKey()

        let contract = TronTransactionContractBuiler()
            .type(.transferContract)
            .parameter(
                from: Crypto.base58Decode("TGQaQoCM7LprSH4TE4FemmZhEQMZMKvAGH")!,
                to: Crypto.base58Decode("TKbhYo6a8nDjfVryNwh4oG5GA7kXfVSyqf")!,
                amount: 1100000
            )
            .build()

        let rawData = TronTransactionRawDataBuilder()
            .timestamp(0)
            .expiration(1536926241000)
            .blockBytes("b238".hexadecimal()!)
            .blockHash("3b15cb7e4a1c8168".hexadecimal()!)
            .contract(contract)
            .data("Test 1.1".data(using: .utf8)!)
            .build()
        
        let rawDataHexString = "0a02b23822083b15cb7e4a1c816840e8a1c5bfdd2c520a54657374253230312e315a67080112630a2d747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e5472616e73666572436f6e747261637412320a1541469d067b0d0ab59ef5399cc9c9cf6ca2bc129a43121541699fefc95ac273a3b4188efc68fd4b26ca85ec5218e09143"

        XCTAssertEqual(
            """
            {"refBlockBytes":"sjg=","refBlockHash":"OxXLfkocgWg=","expiration":"1536926241000","data":"VGVzdCAxLjE=","contract":[{"type":"TransferContract","parameter":{"@type":"type.googleapis.com/protocol.TransferContract","ownerAddress":"QUadBnsNCrWe9TmcycnPbKK8EppD","toAddress":"QWmf78lawnOjtBiO/Gj9SybKhexS","amount":"1100000"}}]}
            """, try! rawData.jsonString())

        var transactionToBeSigned = TronTransaction()

        let hashHexString = transactionToBeSigned.hash().hexString
        let result = transactionToBeSigned.sign(privateKey: privateKey.data)

        XCTAssertEqual("TGQaQoCM7LprSH4TE4FemmZhEQMZMKvAGH", Tron().address(for: publicKey).description)
        XCTAssertEqual(64, hashHexString.count)
        XCTAssertEqual(result.count, 65)
        XCTAssertTrue(Crypto.verify(signature: result, message: Data(hexString: hashHexString)!, publicKey: publicKey.data))
        XCTAssertTrue(transactionToBeSigned.hasSignature)
        XCTAssertEqual("e26f125d0e48e33efeb89efd616bfb7fb73e5a558f4ef8ac0094c3d7ad3a27962a2703ae02513bf98e452c50de4de4b9b118c259b68fa9866d99575f66df8d3d00", result.hexString)
    }
}

// https://api.tronscan.org/#/Transactions/findAll
// https://tronscan.org/#/transaction/3d9fdb03efac1b2fa58cd92b7c283eb76a232cbc434790c8ca684255a7f212b6
// GetTransactionById 3d9fdb03efac1b2fa58cd92b7c283eb76a232cbc434790c8ca684255a7f212b6
/*
 hash:
 8638224c089fa9671874b6caf9e0684c37d19bd199247c2091445cb1f75f0cf0
 txid:
 3d9fdb03efac1b2fa58cd92b7c283eb76a232cbc434790c8ca684255a7f212b6
 raw_data:
 {
 ref_block_bytes: b238
 ref_block_hash: 3b15cb7e4a1c8168
 contract:
 {
 contract 0 :::
 [
 contract_type: TransferContract
 owner_address: TGQaQoCM7LprSH4TE4FemmZhEQMZMKvAGH
 to_address: TKbhYo6a8nDjfVryNwh4oG5GA7kXfVSyqf
 amount: 1100000
 ]

 }
 timestamp: Thu Jan 01 10:00:00 AEST 1970
 fee_limit: 0
 }
 signature:
 {
 signature 0 :e26f125d0e48e33efeb89efd616bfb7fb73e5a558f4ef8ac0094c3d7ad3a2796d5d8fc51fdaec40671bad3af21b21b4509961a8cf8b8f6b55239072d6956b40401
 }
 */

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

    func data(_ data: Data) -> TronTransactionRawDataBuilder {
        rawData.data = data
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

    func parameter(from: Data, to: Data, amount: Int64) -> TronTransactionContractBuiler {
        var transferContract = Protocol_TransferContract()

        transferContract.ownerAddress = from
        transferContract.toAddress = to
        transferContract.amount = amount

        let parameter = try! Google_Protobuf_Any.init(message: transferContract)

        contract.parameter = parameter

        return self
    }

    func build() -> TronTransaction.Contract {
        return contract
    }
}
