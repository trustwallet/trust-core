// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct BitcoinTransaction: BinaryEncoding {
    /// Transaction data format version (note, this is signed)
    public var version: Int32

    /// A list of 1 or more transaction inputs or sources for coins
    public var inputs: [BitcoinTransactionInput]

    /// A list of 1 or more transaction outputs or destinations for coins
    public var outputs: [BitcoinTransactionOutput]

    /// The block number or timestamp at which this transaction is unlocked
    ///
    ///     | Value          | Description
    ///     |----------------|------------
    ///     |  0             | Not locked
    ///     | < 500000000    | Block number at which this transaction is unlocked
    ///     | >= 500000000   | UNIX timestamp at which this transaction is unlocked
    ///
    /// If all inputs have final (`0xffffffff`) sequence numbers then `lockTime` is irrelevant. Otherwise, the
    /// transaction may not be added to a block until after `lockTime`.
    public var lockTime: UInt32

    public var hasWitness: Bool {
        return inputs.contains(where: { !$0.scriptWitness.isEmpty })
    }

    public init(version: Int32, inputs: [BitcoinTransactionInput], outputs: [BitcoinTransactionOutput], lockTime: UInt32) {
        self.version = version
        self.inputs = inputs
        self.outputs = outputs
        self.lockTime = lockTime
    }

    public func encode(into data: inout Data) {
        version.encode(into: &data)

        let encodeWitness = hasWitness
        if encodeWitness {
            // Use extended format in case witnesses are to be serialized.
            let vinDummy = [BitcoinTransactionInput]()
            vinDummy.encode(into: &data)
            data.append(1)
        }

        inputs.encode(into: &data)
        outputs.encode(into: &data)

        if encodeWitness {
            for input in inputs {
                input.scriptWitness.encode(into: &data)
            }
        }

        lockTime.encode(into: &data)
    }

    public var hash: Data {
        var data = Data()
        encode(into: &data)
        return Crypto.sha256sha256(data)
    }

    public var identifier: String {
        return Data(hash.reversed()).hexString
    }
}

public final class BitcoinTransactionInput: BinaryEncoding {
    /// Setting `sequence` to this value for every input in a transaction disables `lockTime`.
    public static let sequenceFinal = 0xffffffff as UInt32

    /// The previous output transaction reference, as an OutPoint structure
    public var previousOutput: BitcoinOutPoint

    /// Computational Script for confirming transaction authorization
    public var script: BitcoinScript

    /// Transaction version as defined by the sender.
    ///
    /// Intended for "replacement" of transactions when information is updated before inclusion into a block.
    public var sequence: UInt32

    public var scriptWitness = BitcoinScriptWitness()

    public init(previousOutput: BitcoinOutPoint, script: BitcoinScript, sequence: UInt32) {
        self.previousOutput = previousOutput
        self.script = script
        self.sequence = sequence
    }

    public func encode(into data: inout Data) {
        previousOutput.encode(into: &data)
        script.encode(into: &data)
        sequence.encode(into: &data)
    }
}

public struct BitcoinOutPoint: BinaryEncoding, Equatable {
    /// The hash of the referenced transaction.
    public var hash: Data

    /// The index of the specific output in the transaction. The first output is 0, etc.
    public var index: UInt32

    public init(hash: Data, index: UInt32) {
        precondition(hash.count == 32)
        self.hash = hash
        self.index = index
    }

    public mutating func setNull() {
        hash.removeAll()
        index = UInt32(bitPattern: -1)
    }

    public var isNull: Bool {
        return hash.isEmpty && index == UInt32(bitPattern: -1)
    }

    public static func == (lhs: BitcoinOutPoint, rhs: BitcoinOutPoint) -> Bool {
        return lhs.hash == rhs.hash && lhs.index == rhs.index
    }

    public func encode(into data: inout Data) {
        data.append(contentsOf: hash)
        index.encode(into: &data)
    }
}

public final class BitcoinTransactionOutput: BinaryEncoding, Equatable {
    /// Transaction Value
    public var value: Int64

    /// Usually contains the public key as a Bitcoin script setting up conditions to claim this output.
    public var script: BitcoinScript

    public static func == (lhs: BitcoinTransactionOutput, rhs: BitcoinTransactionOutput) -> Bool {
        return lhs.value == rhs.value && lhs.script.bytes == rhs.script.bytes
    }

    public init() {
        value = -1
        script = BitcoinScript(bytes: [])
    }

    /// Builds an output with a P2PKH script.
    public init(payToPublicKeyHash address: BitcoinAddress, amount: Int64) {
        value = amount
        script = BitcoinScript.buildPayToPublicKeyHash(address: address)
    }

    public var isNull: Bool {
        return value == -1
    }

    public init(value: Int64, script: BitcoinScript) {
        self.value = value
        self.script = script
    }

    public func encode(into data: inout Data) {
        value.encode(into: &data)
        script.encode(into: &data)
    }
}

public struct BitcoinScriptWitness: CustomStringConvertible, BinaryEncoding {
    public var stack = [Data]()

    public init() {}

    public var isEmpty: Bool {
        return stack.isEmpty
    }

    public var description: String {

        return "ScriptWitness(" + stack.map({ var data = Data(); $0.encode(into: &data); return data.hexString }).joined(separator: ", ") + ")"
    }

    public func encode(into data: inout Data) {
        writeCompactSize(stack.count, into: &data)
        for item in stack {
            writeCompactSize(item.count, into: &data)
            item.encode(into: &data)
        }
    }
}
