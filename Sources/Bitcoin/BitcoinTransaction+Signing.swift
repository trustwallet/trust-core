// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import BigInt
import Foundation
import TrezorCrypto

public extension BitcoinTransaction {
    func getPrevoutHash() -> Data {
        var data = Data()
        for input in inputs {
            input.previousOutput.encode(into: &data)
        }
        return Crypto.sha256sha256(data)
    }

    func getSequenceHash() -> Data {
        var data = Data()
        for input in inputs {
            input.sequence.encode(into: &data)
        }
        return Crypto.sha256sha256(data)
    }

    func getOutputsHash() -> Data {
        var data = Data()
        for output in outputs {
            output.encode(into: &data)
        }
        return Crypto.sha256sha256(data)
    }

    func getPreImage(scriptCode: BitcoinScript, index: Int, hashType: SignatureHashType, amount: Int64) -> Data {
        assert(index < inputs.count)

        var hashPrevouts = Data(repeating: 0, count: 32)
        var hashSequence = Data(repeating: 0, count: 32)
        var hashOutputs = Data(repeating: 0, count: 32)

        if !hashType.contains(.anyoneCanPay) {
            hashPrevouts = getPrevoutHash()
        }

        if !hashType.contains(.anyoneCanPay) && !hashType.single && !hashType.none {
            hashSequence = getSequenceHash()
        }

        if !hashType.single && !hashType.none {
            hashOutputs = getOutputsHash()
        } else if hashType.single && index < outputs.count {
            var data = Data()
            outputs[index].encode(into: &data)
            hashOutputs = Crypto.sha256sha256(data)
        }

        var data = Data()
        // Version
        version.encode(into: &data)

        // Input prevouts/nSequence (none/all, depending on flags)
        hashPrevouts.encode(into: &data)
        hashSequence.encode(into: &data)

        // The input being signed (replacing the scriptSig with scriptCode + amount)
        // The prevout may already be contained in hashPrevout, and the nSequence
        // may already be contain in hashSequence.
        inputs[index].previousOutput.encode(into: &data)
        scriptCode.encode(into: &data)
        amount.encode(into: &data)
        inputs[index].sequence.encode(into: &data)

        // Outputs (none/one/all, depending on flags)
        hashOutputs.encode(into: &data)

        // Locktime
        lockTime.encode(into: &data)

        // Sighash type
        hashType.rawValue.encode(into: &data)

        return data
    }

    /// Generates the signature hash for Witness version 0 scripts.
    func getSignatureHash(scriptCode: BitcoinScript, index: Int, hashType: SignatureHashType, amount: Int64) -> Data {
        let preimage = getPreImage(scriptCode: scriptCode, index: index, hashType: hashType, amount: amount)
        return Crypto.sha256sha256(preimage)
    }

    /// Generates the signature hash for for scripts other than witness scripts.
    func getSignatureHashNonWitness(scriptCode: BitcoinScript, index: Int, hashType: SignatureHashType) -> Data {
        assert(index < inputs.count)

        var data = Data()

        version.encode(into: &data)

        let serializedInputCount = hashType.contains(.anyoneCanPay) ? 1 : inputs.count
        writeCompactSize(serializedInputCount, into: &data)
        for subindex in 0 ..< serializedInputCount {
            serializeInput(subindex, scriptCode: scriptCode, index: index, hashType: hashType, into: &data)
        }

        let serializedOutputCount = hashType.contains(.none) ? 0 : (hashType.contains(.single) ? index+1 : outputs.count)
        writeCompactSize(serializedOutputCount, into: &data)
        for subindex in 0 ..< serializedOutputCount {
            if hashType.contains(.single) && subindex != index {
                BitcoinTransactionOutput(value: -1, script: BitcoinScript(bytes: [])).encode(into: &data)
            } else {
                outputs[subindex].encode(into: &data)
            }
        }

        lockTime.encode(into: &data)
        hashType.rawValue.encode(into: &data)

        return Crypto.sha256sha256(data)
    }

    private func serializeInput(_ subindex: Int, scriptCode: BitcoinScript, index: Int, hashType: SignatureHashType, into data: inout Data) {
        // In case of SIGHASH_ANYONECANPAY, only the input being signed is serialized
        var subindex = subindex
        if hashType.contains(.anyoneCanPay) {
            subindex = index
        }

        inputs[subindex].previousOutput.encode(into: &data)

        // Serialize the script
        if subindex != index {
            writeCompactSize(0, into: &data)
        } else {
            serializeScriptCode(scriptCode, into: &data)
        }

        // Serialize the nSequence
        if subindex != index && (hashType.contains(.single) || hashType.contains(.none)) {
            0.encode(into: &data)
        } else {
            inputs[subindex].sequence.encode(into: &data)
        }
    }

    private func serializeScriptCode(_ script: BitcoinScript, into data: inout Data) {
        var index = 0
        var opcode = 0 as UInt8
        var contents = Data()

        var separators = 0
        while script.getScriptOp(index: &index, opcode: &opcode, contents: &contents) {
            if opcode == OpCode.OP_CODESEPARATOR {
                separators += 1
            }
        }
        writeCompactSize(script.data.count - separators, into: &data)

        var chunkStart = 0
        index = 0
        while script.getScriptOp(index: &index, opcode: &opcode, contents: &contents) {
            if opcode == OpCode.OP_CODESEPARATOR {
                data.append(script.data[chunkStart ..< index])
                chunkStart = index
            }
        }
        data.append(script.data[chunkStart...])
    }
}
