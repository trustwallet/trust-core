// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
@testable import TrustCore

class BitcoinUnspentSelectorTests: XCTestCase {
    let selector = BitcoinUnspentSelector(byteFee: 1)
    let transactionOutPoint = BitcoinOutPoint(hash: Data.init(count: 32), index: 0)

    // swiftlint:disable:next function_body_length
    func testSelectUnpsents() {
        // 1. Single Tx about 2x
        do {
            var utxos = [BitcoinUnspentTransaction]()
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 4000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 2000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 6000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 1000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 11000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 12000, script: BitcoinScript()), outpoint: transactionOutPoint))
            let (selectedOutputs, _) = try selector.select(from: utxos, targetValue: 5000)
            XCTAssertEqual(selectedOutputs.count, 1)
            XCTAssertEqual(selectedOutputs[0].output.value, 11000)
        } catch {
            XCTFail("Some Error: \(error)")
        }

        // 2. Single smallest Tx greater than 1x
        do {
            var utxos = [BitcoinUnspentTransaction]()
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 4000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 2000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 6000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 1000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 50000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 120000, script: BitcoinScript()), outpoint: transactionOutPoint))

            let (selectedOutputs, _) = try selector.select(from: utxos, targetValue: 10000)
            XCTAssertEqual(selectedOutputs.count, 1)
            XCTAssertEqual(selectedOutputs[0].output.value, 50000)
        } catch {
            XCTFail("Some Error: \(error)")
        }

        // 3. Two Txs about 2x value of target
        do {
            var utxos = [BitcoinUnspentTransaction]()
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 4000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 2000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 5000, script: BitcoinScript()), outpoint: transactionOutPoint))

            let (selectedOutputs, _) = try selector.select(from: utxos, targetValue: 6000)
            XCTAssertEqual(selectedOutputs.count, 2)
            XCTAssertEqual(selectedOutputs[0].output.value, 4000)
            XCTAssertEqual(selectedOutputs[1].output.value, 5000)
        } catch {
            XCTFail("Some Error: \(error)")
        }

        // 4. Two smallest Txs greater than 1x
        do {
            var utxos = [BitcoinUnspentTransaction]()
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 40000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 30000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 30000, script: BitcoinScript()), outpoint: transactionOutPoint))

            let (selectedOutputs, _) = try selector.select(from: utxos, targetValue: 50000)
            XCTAssertEqual(selectedOutputs.count, 2)
            XCTAssertEqual(selectedOutputs[0].output.value, 30000)
            XCTAssertEqual(selectedOutputs[1].output.value, 40000)
        } catch {
            XCTFail("Some Error: \(error)")
        }

        // 5. Multiple smallest txs greater than 1x
        do {
            var utxos = [BitcoinUnspentTransaction]()
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 1000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 2000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 3000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 4000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 5000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 6000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 7000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 8000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 9000, script: BitcoinScript()), outpoint: transactionOutPoint))

            let (selectedOutputs, _) = try selector.select(from: utxos, targetValue: 28000)
            XCTAssertEqual(selectedOutputs.count, 4)
            XCTAssertEqual(selectedOutputs[0].output.value, 6000)
            XCTAssertEqual(selectedOutputs[1].output.value, 7000)
            XCTAssertEqual(selectedOutputs[2].output.value, 8000)
            XCTAssertEqual(selectedOutputs[3].output.value, 9000)
        } catch {
            XCTFail("Some Error: \(error)")
        }

        // 6. Insufficient Fund
        do {
            var utxos = [BitcoinUnspentTransaction]()
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 4000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 4000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 4000, script: BitcoinScript()), outpoint: transactionOutPoint))

            do {
                _ = try selector.select(from: utxos, targetValue: 15000)
                XCTFail("Should throw 'insufficientUtxos'")
            } catch BitcoinUnspentSelectorError.insufficientFunds {
                // Success
            } catch {
                XCTFail("Unknown error occurred")
            }
        }

        // 7. Insufficient funds because of fee
        do {
            var utxos = [BitcoinUnspentTransaction]()
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 4000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 4000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 4000, script: BitcoinScript()), outpoint: transactionOutPoint))

            do {
                _ = try selector.select(from: utxos, targetValue: 12000)
                XCTFail("Should throw 'insufficientUtxos'")
            } catch BitcoinUnspentSelectorError.insufficientFunds {
                // Success
            } catch {
                XCTFail("Unknown error occurred")
            }
        }
    }

    func testDiscardDust() {
        // 8. Use all txs with discarding dust change
        do {
            var utxos = [BitcoinUnspentTransaction]()
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 4000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 4000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 4000, script: BitcoinScript()), outpoint: transactionOutPoint))

            let (selectedOutputs, fee) = try selector.select(from: utxos, targetValue: 11000)
            print("fee = ", fee)
            XCTAssertEqual(selectedOutputs.count, 3)
            XCTAssertEqual(selectedOutputs[0].output.value, 4000)
            XCTAssertEqual(selectedOutputs[1].output.value, 4000)
            XCTAssertEqual(selectedOutputs[2].output.value, 4000)
        } catch {
            XCTFail("Some Error: \(error)")
        }

        // 9. not select dust change
        do {
            var utxos = [BitcoinUnspentTransaction]()
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 2000, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 5100, script: BitcoinScript()), outpoint: transactionOutPoint))
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 10000, script: BitcoinScript()), outpoint: transactionOutPoint))

            let (selectedOutputs, _) = try selector.select(from: utxos, targetValue: 15000)
            XCTAssertEqual(selectedOutputs.count, 3)
            XCTAssertEqual(selectedOutputs[0].output.value, 2000)
            XCTAssertEqual(selectedOutputs[1].output.value, 5100)
            XCTAssertEqual(selectedOutputs[2].output.value, 10000)
        } catch {
            XCTFail("Some Error: \(error)")
        }

        let selector2 = BitcoinUnspentSelector(byteFee: 1, dustThreshold: 10000)

        // 10. Discard dust tx with Single utxo
        do {
            var utxos = [BitcoinUnspentTransaction]()
            utxos.append(BitcoinUnspentTransaction(output: BitcoinTransactionOutput(value: 79618, script: BitcoinScript()), outpoint: transactionOutPoint))

            let (selectedOutputs, _) = try selector2.select(from: utxos, targetValue: 70838)
            XCTAssertEqual(selectedOutputs.count, 1)
            XCTAssertEqual(selectedOutputs[0].output.value, 79618)

        } catch {
            XCTFail("Unknown error occurred")
        }

        // 11. Target is zero and no utxo
        do {
            let (selectedOutputs, _) = try selector2.select(from: [], targetValue: 0)
            XCTAssertEqual(selectedOutputs.count, 0)
        } catch {
            XCTFail("Unknown error occurred")
        }
    }

    func testCalculateFee() {
        // 1. default nOut and byteFee
        XCTAssertEqual(selector.calculateFee(nIn: 1), 226)
        XCTAssertEqual(selector.calculateFee(nIn: 2), 374)
        XCTAssertEqual(selector.calculateFee(nIn: 3), 522)

        // 2. default byteFee
        XCTAssertEqual(selector.calculateFee(nIn: 1, nOut: 1), 192)
        XCTAssertEqual(selector.calculateFee(nIn: 1, nOut: 2), 226)
        XCTAssertEqual(selector.calculateFee(nIn: 2, nOut: 1), 340)
        XCTAssertEqual(selector.calculateFee(nIn: 2, nOut: 2), 374)
        XCTAssertEqual(selector.calculateFee(nIn: 3, nOut: 1), 488)
        XCTAssertEqual(selector.calculateFee(nIn: 3, nOut: 2), 522)
    }
}
