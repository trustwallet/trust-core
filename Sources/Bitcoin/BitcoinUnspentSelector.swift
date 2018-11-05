// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

enum BitcoinUnspentSelectorError: LocalizedError {
    case insufficientFunds
    case error(String)
}

public struct BitcoinUnspentSelector {
    public let byteFee: Int64
    public let dustThreshold: Int64

    public init(byteFee: Int64 = 1, dustThreshold: Int64 = 3 * 182 + 1000) {
        self.byteFee = byteFee
        self.dustThreshold = dustThreshold
    }

    public func select(from utxos: [BitcoinUnspentTransaction], targetValue: Int64) throws -> (utxos: [BitcoinUnspentTransaction], fee: Int64) {
        // if target value is zero, fee is zero
        guard targetValue > 0 else {
            return ([], 0)
        }

        // definitions for the following caluculation
        let doubleTargetValue = targetValue * 2
        var numOutputs = 2 // if allow multiple output, it will be changed.
        var numInputs = 2
        var fee: Int64 {
            return calculateFee(nIn: numInputs, nOut: numOutputs)
        }
        var targetWithFee: Int64 {
            return targetValue + fee
        }
        var targetWithFeeAndDust: Int64 {
            return targetWithFee + dustThreshold
        }

        let sortedUtxos: [BitcoinUnspentTransaction] = utxos.sorted(by: { $0.output.value < $1.output.value })

        // total values of utxos should be greater than targetValue
        guard sortedUtxos.sum() >= targetValue && !sortedUtxos.isEmpty else {
            throw BitcoinUnspentSelectorError.insufficientFunds
        }

        // difference from 2x targetValue
        func distFrom2x(_ val: Int64) -> Int64 {
            if val > doubleTargetValue { return val - doubleTargetValue } else { return doubleTargetValue - val }
        }

        // 1. Find a combination of the fewest outputs that is
        //    (1) bigger than what we need
        //    (2) closer to 2x the amount,
        //    (3) and does not produce dust change.
        txN:do {
            for numTx in (1...sortedUtxos.count) {
                numInputs = numTx
                let nOutputsSlices = sortedUtxos.eachSlices(numInputs)
                var nOutputsInRange = nOutputsSlices.filter { $0.sum() >= targetWithFeeAndDust }
                nOutputsInRange.sort { distFrom2x($0.sum()) < distFrom2x($1.sum()) }
                if let nOutputs = nOutputsInRange.first {
                    return (nOutputs, fee)
                }
            }
        }

        // 2. If not, find a combination of outputs that may produce dust change.
        txDiscardDust:do {
            for numTx in (1...sortedUtxos.count) {
                numInputs = numTx
                let nOutputsSlices = sortedUtxos.eachSlices(numInputs)
                let nOutputsInRange = nOutputsSlices.filter {
                    return $0.sum() >= targetWithFee
                }
                if let nOutputs = nOutputsInRange.first {
                    return (nOutputs, fee)
                }
            }
        }

        throw BitcoinUnspentSelectorError.insufficientFunds
    }

    private func calculateFee(nIn: Int, nOut: Int = 2) -> Int64 {
        var txsize: Int {
            return ((148 * nIn) + (34 * nOut) + 10)
        }
        return Int64(txsize) * byteFee
    }
}

private extension Array {
    // Slice Array
    // [0,1,2,3,4,5,6,7,8,9].eachSlices(3)
    // >
    // [[0, 1, 2], [1, 2, 3], [2, 3, 4], [3, 4, 5], [4, 5, 6], [5, 6, 7], [6, 7, 8], [7, 8, 9]]
    func eachSlices(_ num: Int) -> [[Element]] {
        let slices = (0...count - num).map { self[$0..<$0 + num].map { $0 } }
        return slices
    }
}

private extension Sequence where Element == BitcoinUnspentTransaction {
    func sum() -> Int64 {
        return reduce(0) { $0 + $1.output.value }
    }
}
