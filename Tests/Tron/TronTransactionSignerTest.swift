// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore

class TronContractTests: XCTestCase {
    
    func testTronTransaction() {
        let from = BitcoinAddress(string: "TJRyWwFs9wTFGZg3JbrVriFbNfCug5tDeC")!
        let to = BitcoinAddress(string: "THTR75o8xXAgCTQqpiot2AFRAjvW1tSbVV")!
        let amount = Int64(2000000)
        
        let contract = TronContract(from: from, to: to, amount: amount)
        
        let timestamp = Int64(1539295479000)
        let txTrieRoot = Data(hexString: "64288c2db0641316762a99dbb02ef7c90f968b60f9f2e410835980614332f86d")!
        let parentHash =  Data(hexString: "00000000002f7b3af4f5f8b9e23a30c530f719f165b742e7358536b280eead2d")!
        let number = Int64(3111739)
        let witnessAddress = Data(hexString: "415863f6091b8e71766da808b1dd3159790f61de7d")!
        let version = Int32(3)
        
        let block = TronBlock(timestamp: timestamp, txTrieRoot: txTrieRoot, parentHash: parentHash, number: number, witnessAddress: witnessAddress, version: version)
        let tronTransaction = TronTransaction(tronContract: contract, tronBlock: block, timestamp: Date(timeIntervalSince1970: 1539295479))
        
        var sighn = TronSighn(tronTransaction: tronTransaction)
        let privateKey =  PrivateKey(data: Data(hexString: "2d8f68944bdbfbc0769542fba8fc2d2a3de67393334471624364c7006da2aa54")!)!
        
        try! sighn.sign(hashSigner: { data in
            return Crypto.sign(hash: data, privateKey: privateKey.data)
        })
        
        XCTAssertEqual(sighn.signature?.hexString, "a196cbb093ebb6924b939d3b6a77506f2045ef0f53b426703701937ce98e268155040b6bfcd4c6c5ddbdbced66e31e652ecedfc7d85735a14851c7f491621ae701")
    }
    
}
