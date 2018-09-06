// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

// 1 - создать транзакцию
// 2 - проверить ее хеш
// 3 - подписать транзакцию

// 4 - проверить сериализацию всех частей транзакции и транзакции в целом
// 5 - проверить десериализацию всех частей транзакции и транзакции в целом

class NeoSignTests: XCTestCase {

    func createUnsignedTx() -> NeoTransaction {
        let attributes: [Attribute] = []

        let inputs = [
            NeoTransactionInput(
                    prevHash: Data(hexString: "22555bfe765497956f4194d40c0e8cf8068b97517799061e450ad2468db2a7c4")!,
                    prevIndx: 1), ]

        let outputs = [
            NeoTransactionOutput(
                    assetId: Data(hexString: "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b")!,
                    value: 1,
                    scriptHash: Data(hexString: "cef0c0fdcfe7838eff6ff104f9cdec2922297537")!),
            NeoTransactionOutput(
                    assetId: Data(hexString: "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b")!,
                    value: 4714,
                    scriptHash: Data(hexString: "5df31f6f59e6a4fbdd75103786bf73db1000b235")!), ]

        let scripts = [
            Script(
                    stackScript: [Data(hexString: "4051c2e6e2993c6feb43383131ed2091f4953747d3e16ecad752cdd90203a992dea0273e98c8cd09e9bfcf2dab22ce843429cdf0fcb9ba4ac93ef1aeef40b20783")!],
                    redeemScript: [Data(hexString: "21031d8e1630ce640966967bc6d95223d21f44304133003140c3b52004dc981349c9ac")!]), ]

        return NeoTransaction(
                txType: 128,
                version: 0,
                attributes: attributes,
                inputs: inputs,
                outputs: outputs,
                scripts: scripts
        )
    }

    func testEncode() {
        let tx = createUnsignedTx()
        var encoded = Data()
        tx.encode(into: &encoded)
        print(encoded)
        print(encoded.hexString)
        // swiftlint:disable:next line_length
        XCTAssertEqual(encoded.hexString, "8000000122555bfe765497956f4194d40c0e8cf8068b97517799061e450ad2468db2a7c4010002c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b0100000000000000cef0c0fdcfe7838eff6ff104f9cdec2922297537c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b6a120000000000005df31f6f59e6a4fbdd75103786bf73db1000b23501014051c2e6e2993c6feb43383131ed2091f4953747d3e16ecad752cdd90203a992dea0273e98c8cd09e9bfcf2dab22ce843429cdf0fcb9ba4ac93ef1aeef40b207830121031d8e1630ce640966967bc6d95223d21f44304133003140c3b52004dc981349c9ac")

    }

    func testPrivateKey() {
        let privateKey = PrivateKey()
        print(privateKey)
        XCTAssertNotNil(privateKey)
    }
}
