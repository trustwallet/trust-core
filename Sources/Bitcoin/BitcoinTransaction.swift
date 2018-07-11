// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct BitcoinTransaction {
    /// Transaction data format version (note, this is signed)
    var version: Int32

    /// A list of 1 or more transaction inputs or sources for coins
    var inputs: [BitcoinTransactionInput]

    /// A list of 1 or more transaction outputs or destinations for coins
    var outputs: [BitcoinTransactionOutput]

    /// The block number or timestamp at which this transaction is unlocked
    ///
    ///     | Value          | Description
    ///     |----------------|------------
    ///     |  0             | Not locked
    ///     | < 500000000    | Block number at which this transaction is unlocked
    ///     | >= 500000000   | UNIX timestamp at which this transaction is unlocked
    ///
    /// If all TxIn inputs have final (`0xffffffff`) sequence numbers then `lockTime` is irrelevant. Otherwise, the
    /// transaction may not be added to a block until after `lockTime`.
    var lockTime: UInt32
}

public struct BitcoinTransactionInput {
    /// The previous output transaction reference, as an OutPoint structure
    var previousOutput: BitcoinOutPoint

    /// Computational Script for confirming transaction authorization
    var script: Data

    /// Transaction version as defined by the sender.
    ///
    /// Intended for "replacement" of transactions when information is updated before inclusion into a block.
    var sequence: Int
}

public struct BitcoinOutPoint {
    /// The hash of the referenced transaction.
    var hash: Data

    /// The index of the specific output in the transaction. The first output is 0, etc.
    var index: Int
}

public struct BitcoinTransactionOutput {
    /// Transaction Value
    var value: Int64

    /// Usually contains the public key as a Bitcoin script setting up conditions to claim this output.
    var script: Data
}
