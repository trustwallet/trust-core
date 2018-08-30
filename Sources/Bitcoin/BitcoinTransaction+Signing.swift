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

    func getSignatureHash(scriptCode: BitcoinScript, index: Int, hashType: SignatureHashType, amount: Int64) -> Data {
        assert(index < inputs.count)

        var hashPrevouts = Data()
        var hashSequence = Data()
        var hashOutputs = Data()

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

        return Crypto.sha256sha256(data)
    }
}
