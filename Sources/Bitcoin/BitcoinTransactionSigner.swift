// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import BigInt
import Foundation
import TrezorCrypto

public final class BitcoinTransactionSigner {
    public var keyProvider: BitcoinPrivateKeyProvider
    public var transaction: BitcoinTransaction
    public var hashType: SignatureHashType
    private var signedInputs = [BitcoinTransactionInput]()

    public init(keyProvider: BitcoinPrivateKeyProvider, transaction: BitcoinTransaction, hashType: SignatureHashType = [.all, .fork]) {
        self.keyProvider = keyProvider
        self.transaction = transaction
        self.hashType = hashType
    }

    public func sign(_ utxos: [BitcoinUnspentTransaction]) throws -> BitcoinTransaction {
        signedInputs = transaction.inputs

        for (i, utxo) in zip(utxos.indices, utxos) {
            // Only sign SIGHASH_SINGLE if there's a corresponding output
            if hashType.contains(.single) && i >= transaction.outputs.count {
                continue
            }
            try sign(script: utxo.output.script, index: i, utxo: utxo)
        }

        return BitcoinTransaction(version: transaction.version, inputs: signedInputs, outputs: transaction.outputs, lockTime: transaction.lockTime)
    }

    private func sign(script: BitcoinScript, index: Int, utxo: BitcoinUnspentTransaction) throws {
        var script = script
        var redeemScript: BitcoinScript?
        var witnessStack = [Data]()

        var results = try signStep(script: script, index: index, utxo: utxo, version: .base)
        let txin = transaction.inputs[index]

        if script.isPayToScriptHash {
            script = BitcoinScript(data: results.first!)
            results = try signStep(script: script, index: index, utxo: utxo, version: .base)
            results.append(script.data)
            redeemScript = script
        }

        if script.matchPayToWitnessPublicKeyHash() != nil {
            let witnessScript = BitcoinScript.buildPayToPublicKeyHash(results[0])
            results = try signStep(script: witnessScript, index: index, utxo: utxo, version: .witnessV0)
            witnessStack = results
            results = []
        } else if script.matchPayToWitnessScriptHash() != nil {
            let witnessScript = BitcoinScript(data: results[0])
            results = try signStep(script: witnessScript, index: index, utxo: utxo, version: .witnessV0)
            results.append(witnessScript.data)

            witnessStack = results
            results = []
        } else if script.isWitnessProgram {
            // Unrecognized witness program.
            throw Error.invalidOutputScript
        }

        if let redeemScript = redeemScript {
            results.append(redeemScript.data)
        }

        signedInputs[index] = BitcoinTransactionInput(previousOutput: txin.previousOutput, script: BitcoinScript(data: pushAll(results)), sequence: txin.sequence)
        signedInputs[index].scriptWitness.stack = witnessStack
    }

    private func signStep(script: BitcoinScript, index: Int, utxo: BitcoinUnspentTransaction, version: SignatureVersion) throws -> [Data] {
        let transactionToSign = BitcoinTransaction(version: transaction.version, inputs: signedInputs, outputs: transaction.outputs, lockTime: transaction.lockTime)

        if let scriptHash = script.matchPayToScriptHash() {
            guard let redeemScript = keyProvider.script(forScriptHash: scriptHash) else {
                throw Error.missingRedeemScript
            }
            return [redeemScript.data]
        } else if let witnessScript = script.matchPayToWitnessScriptHash() {
            let scripthash = Crypto.ripemd160(witnessScript)
            guard let redeemScript = keyProvider.script(forScriptHash: scripthash) else {
                throw Error.missingRedeemScript
            }
            return [redeemScript.data]
        } else if let keyhash = script.matchPayToWitnessPublicKeyHash() {
            return [keyhash]
        } else if script.isWitnessProgram {
            throw Error.invalidOutputScript
        } else if let (keys, required) = script.matchMultisig() {
            var results = [Data()] // workaround CHECKMULTISIG bug
            for pubKey in keys {
                if results.count >= required + 1 {
                    break
                }
                guard let key = keyProvider.key(forPublicKey: pubKey) else {
                    throw Error.missingKey
                }
                let signature = createSignature(transaction: transactionToSign, script: script, key: key, index: index, amount: utxo.output.value, version: version)
                results.append(signature)
            }
            results.append(contentsOf: Array(repeating: Data(), count: required + 1 - results.count))
            return results
        } else if let pubKey = script.matchPayToPubkey() {
            guard let key = keyProvider.key(forPublicKey: pubKey) else {
                throw Error.missingKey
            }
            let signature = createSignature(transaction: transactionToSign, script: script, key: key, index: index, amount: utxo.output.value, version: version)
            return [signature]
        } else if let keyHash = script.matchPayToPubkeyHash() {
            guard let key = keyProvider.key(forPublicKeyHash: keyHash) else {
                throw Error.missingKey
            }
            let pubkey = key.publicKey(compressed: true)
            let signature = createSignature(transaction: transactionToSign, script: script, key: key, index: index, amount: utxo.output.value, version: version)
            return [signature, pubkey.data]
        } else {
            throw Error.invalidOutputScript
        }
    }

    private func createSignature(transaction: BitcoinTransaction, script: BitcoinScript, key: PrivateKey, index: Int, amount: Int64, version: SignatureVersion) -> Data {
        let sighash = transaction.getSignatureHash(scriptCode: script, index: index, hashType: hashType, amount: amount, version: version)
        return key.signAsDER(hash: sighash) + Data(bytes: [UInt8(hashType.rawValue)])
    }

    private func pushAll(_ results: [Data]) -> Data {
        var data = Data()
        for result in results {
            if result.isEmpty {
                data.append(OpCode.OP_0)
            } else if result.count == 1 && result[0] >= 1 && result[0] <= 16 {
                data.append(BitcoinScript.encodeNumber(Int(result[0])))
            } else if result.count < OpCode.OP_PUSHDATA1 {
                data.append(UInt8(result.count))
            } else if result.count <= 0xff { // swiftlint:disable:this empty_count
                data.append(OpCode.OP_PUSHDATA1)
                data.append(UInt8(result.count))
            } else if result.count <= 0xffff { // swiftlint:disable:this empty_count
                data.append(OpCode.OP_PUSHDATA2)
                let boxed = [UInt16(result.count).littleEndian]
                boxed.withUnsafeBytes {
                    data.append($0.bindMemory(to: UInt8.self))
                }
            } else {
                data.append(OpCode.OP_PUSHDATA4)
                let boxed = [UInt32(result.count).littleEndian]
                boxed.withUnsafeBytes {
                    data.append($0.bindMemory(to: UInt8.self))
                }
            }
            data.append(result)
        }
        return data
    }

    public enum Error: LocalizedError {
        case invalidOutputScript
        case missingRedeemScript
        case missingKey
    }
}
