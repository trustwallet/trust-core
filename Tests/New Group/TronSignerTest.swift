// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
@testable import TrustCore

class TronSignerTest: XCTestCase {
    
    func testSignTransferContractTransaction() {
       
       let ownerAddress = BitcoinAddress(string: "TJRyWwFs9wTFGZg3JbrVriFbNfCug5tDeC")!
       let toAddress =  BitcoinAddress(string: "THTR75o8xXAgCTQqpiot2AFRAjvW1tSbVV")!
       let privateKey = PrivateKey(data: Data(hexString: "2d8f68944bdbfbc0769542fba8fc2d2a3de67393334471624364c7006da2aa54")!)!
       let amount = Int64(1000000)
       let signature = "ab6e9d030a56bae669d45e68a93725e33a115a4adeab1b10c8aab2108ff419e83afa52a06f673c7b0a5d7f7b14d74868a4cd971cbb4c7637b801904f7e2893e000"
                        
       let contract = try! TransferContract(ownerAddress: ownerAddress, toAddress: toAddress, amount: amount).contract()
        
       let rawData = TronTransactionRawDataBuilder()
            .contract(contract)
            .timestamp(1538517720187)
            .expiration(1538517753000)
            .blockBytes(Data())
            .blockHash(Data())
            .build()
        
        var transaction = Protocol_Transaction()
        transaction.rawData = rawData
        
        var signer = TronSigner(transaction: transaction)
        XCTAssertNil(signer.transaction.signature.first)
        signer.sign(key: privateKey.data)
        XCTAssertNotNil(signer.transaction.signature.first)
        XCTAssertEqual(signer.transaction.signature.first!.hexString, signature)
    }
}
