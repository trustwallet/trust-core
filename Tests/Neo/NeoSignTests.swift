//
// Created by KV on 03.09.2018.
// Copyright (c) 2018 Trust. All rights reserved.
//

import TrustCore
import XCTest

// 1 - создать транзакцию
// 2 - проверить ее хеш
// 3 - подписать транзакцию

// 4 - проверить сериализацию всех частей транзакции и транзакции в целом
// 5 - проверить десериализацию всех частей транзакции и транзакции в целом

class NeoSignTests: XCTestCase {

    func createUnsignedTx(){
        let type: UInt8;
        let version: UInt8;
        let attributes: [Attribute];
        let inputs: [NeoTransactionInput];
        let outputs: [NeoTransactionOutput];
        let scripts: [Script];

        return NeoTransaction(
                type: UInt8,
                version: UInt8,
                attributes: [Attribute],
                inputs: [NeoTransactionInput],
                outputs: [NeoTransactionOutput],
                scripts: [Script]);
    }
    func privateKeyTest(){
        let privateKey = PrivateKey()
        print(privateKey)
    }
}