// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct BitcoinUnspentTransaction {
    public var output: BitcoinTransactionOutput
    public var outpoint: BitcoinOutPoint

    public init(output: BitcoinTransactionOutput, outpoint: BitcoinOutPoint) {
        self.output = output
        self.outpoint = outpoint
    }
}
