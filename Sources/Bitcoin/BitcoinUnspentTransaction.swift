// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct BitcoinUnspentTransaction: Equatable {
    public var output: BitcoinTransactionOutput
    public var outpoint: BitcoinOutPoint

    public static func == (lhs: BitcoinUnspentTransaction, rhs: BitcoinUnspentTransaction) -> Bool {
        return lhs.outpoint == rhs.outpoint &&
            lhs.output == rhs.output
    }

    public init(output: BitcoinTransactionOutput, outpoint: BitcoinOutPoint) {
        self.output = output
        self.outpoint = outpoint
    }
}
