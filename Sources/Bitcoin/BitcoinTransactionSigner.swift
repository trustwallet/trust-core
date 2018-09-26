// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import BigInt
import Foundation
import TrezorCrypto

public struct BitcoinTransactionSigner {
    public var keyProvider: BitcoinPrivateKeyProvider

    public init(keyProvider: BitcoinPrivateKeyProvider) {
        self.keyProvider = keyProvider
    }

    public func sign(_ unsignedTx: BitcoinTransaction, utxos: [BitcoinUnspentTransaction], hashType: SignatureHashType = [.all, .fork]) throws -> BitcoinTransaction {
        var inputsToSign = unsignedTx.inputs

        for (i, utxo) in zip(utxos.indices, utxos) {
            guard let key = try keyForScript(utxo.output.script) else {
                // Missing key, can't sign
                continue
            }
            guard let script = try scriptForScript(utxo.output.script) else {
                // Missing script, can't sign
                continue
            }
            let pubkey = key.publicKey(compressed: true)
            let transactionToSign = BitcoinTransaction(version: unsignedTx.version, inputs: inputsToSign, outputs: unsignedTx.outputs, lockTime: unsignedTx.lockTime)
            let txin = inputsToSign[i]

            let unlockScript: BitcoinScript
            if let scriptHash = utxo.output.script.matchPayToScriptHash() {
                guard let redeemScript = keyProvider.script(forScriptHash: scriptHash) else {
                    throw Error.missingRedeemScript
                }
                let sighash: Data
                // TODO: refactor this mess
                let witnessProgram = redeemScript.witnessProgram()
                if witnessProgram != nil {
                    let scriptCode = BitcoinScript(data: Data(bytes: [0x76, 0xa9, 0x14]) + pubkey.bitcoinKeyHash + Data(bytes: [0x88, 0xac]))
                    let preimage = transactionToSign.getPreImage(scriptCode: scriptCode, index: i, hashType: hashType, amount: utxo.output.value)
                    sighash = Crypto.sha256sha256(preimage)
                } else {
                    sighash = transactionToSign.getSignatureHashNonWitness(scriptCode: script, index: i, hashType: hashType)
                }
                let signature = key.signAsDER(hash: sighash) + Data(bytes: [UInt8(hashType.rawValue)])
                if witnessProgram != nil {
                    inputsToSign[i] = BitcoinTransactionInput(previousOutput: txin.previousOutput, script: BitcoinScript(data: Data(bytes: [0x16]) + redeemScript.data), sequence: txin.sequence)
                    inputsToSign[i].scriptWitness.stack.append(signature.encoded)
                    inputsToSign[i].scriptWitness.stack.append(pubkey.data)
                } else {
                    unlockScript = unlockingScript(signature: signature, script: redeemScript, hashType: hashType)
                    inputsToSign[i] = BitcoinTransactionInput(previousOutput: txin.previousOutput, script: unlockScript, sequence: txin.sequence)
                }
            } else if let hash = utxo.output.script.matchPayToWitnessScriptHash() {
                guard let witnessScript = keyProvider.script(forScriptHash: hash) else {
                    throw Error.missingRedeemScript
                }
                let sighash = transactionToSign.getSignatureHash(scriptCode: witnessScript, index: i, hashType: hashType, amount: utxo.output.value)
                let signature = key.signAsDER(hash: sighash) + Data(bytes: [UInt8(hashType.rawValue)])
                inputsToSign[i] = BitcoinTransactionInput(previousOutput: txin.previousOutput, script: BitcoinScript(), sequence: txin.sequence)
                inputsToSign[i].scriptWitness.stack.append(signature.encoded)
                inputsToSign[i].scriptWitness.stack.append(witnessScript.data)
            } else if utxo.output.script.matchPayToWitnessPublicKeyHash() != nil {
                let sighash = transactionToSign.getSignatureHash(scriptCode: script, index: i, hashType: hashType, amount: utxo.output.value)
                let signature = key.signAsDER(hash: sighash) + Data(bytes: [UInt8(hashType.rawValue)])
                inputsToSign[i] = BitcoinTransactionInput(previousOutput: txin.previousOutput, script: BitcoinScript(), sequence: txin.sequence)
                inputsToSign[i].scriptWitness.stack.append(signature.encoded)
                inputsToSign[i].scriptWitness.stack.append(pubkey.data)
            } else if utxo.output.script.witnessProgram() != nil {
                throw Error.invalidOutputScript
            } else if utxo.output.script.matchPayToPubkey() != nil {
                let sighash = transactionToSign.getSignatureHashNonWitness(scriptCode: script, index: i, hashType: hashType)
                let signature = key.signAsDER(hash: sighash)
                unlockScript = unlockingScript(signature: signature, hashType: hashType)
                inputsToSign[i] = BitcoinTransactionInput(previousOutput: txin.previousOutput, script: unlockScript, sequence: txin.sequence)
            } else {
                let sighash = transactionToSign.getSignatureHashNonWitness(scriptCode: script, index: i, hashType: hashType)
                let signature = key.signAsDER(hash: sighash)
                unlockScript = unlockingScript(signature: signature, publicKey: pubkey, hashType: hashType)
                inputsToSign[i] = BitcoinTransactionInput(previousOutput: txin.previousOutput, script: unlockScript, sequence: txin.sequence)
            }
        }

        return BitcoinTransaction(version: unsignedTx.version, inputs: inputsToSign, outputs: unsignedTx.outputs, lockTime: unsignedTx.lockTime)
    }

    private func keyForScript(_ script: BitcoinScript) throws -> PrivateKey? {
        if let pubkeyHash = script.matchPayToPubkeyHash() {
            return keyProvider.key(forPublicKeyHash: pubkeyHash)
        } else if let pubkey = script.matchPayToPubkey() {
            return keyProvider.key(forPublicKey: pubkey)
        } else if let scriptHash = script.matchPayToScriptHash() {
            return keyProvider.key(forScriptHash: scriptHash)
        } else if let pubkeyHash = script.matchPayToWitnessPublicKeyHash() {
            return keyProvider.key(forPublicKeyHash: pubkeyHash)
        } else if let scriptHash = script.matchPayToWitnessScriptHash() {
            return keyProvider.key(forScriptHash: scriptHash)
        } else {
            throw Error.invalidOutputScript
        }
    }

    private func scriptForScript(_ script: BitcoinScript) throws -> BitcoinScript? {
        if script.matchPayToPubkeyHash() != nil {
            return script
        } else if script.matchPayToPubkey() != nil {
            return script
        } else if let scriptHash = script.matchPayToScriptHash() {
            return keyProvider.script(forScriptHash: scriptHash)
        } else if let pubkeyHash = script.matchPayToWitnessPublicKeyHash() {
            return keyProvider.script(forScriptHash: pubkeyHash)
        } else if let scriptHash = script.matchPayToWitnessScriptHash() {
            return keyProvider.script(forScriptHash: scriptHash)
        } else {
            throw Error.invalidOutputScript
        }
    }

    private func unlockingScript(signature: Data, publicKey: PublicKey, hashType: SignatureHashType) -> BitcoinScript {
        var unlockingScriptData = Data()
        unlockingScriptData.append(UInt8(signature.count + 1))
        unlockingScriptData.append(signature)
        unlockingScriptData.append(UInt8(hashType.rawValue))
        writeCompactSize(publicKey.data.count, into: &unlockingScriptData)
        unlockingScriptData.append(publicKey.data)
        return BitcoinScript(data: unlockingScriptData)
    }

    private func unlockingScript(signature: Data, script: BitcoinScript, hashType: SignatureHashType) -> BitcoinScript {
        var unlockingScriptData = Data()
        unlockingScriptData.append(UInt8(signature.count + 1))
        unlockingScriptData.append(signature)
        unlockingScriptData.append(UInt8(hashType.rawValue))
        script.encode(into: &unlockingScriptData)
        return BitcoinScript(data: unlockingScriptData)
    }

    private func unlockingScript(signature: Data, hashType: SignatureHashType) -> BitcoinScript {
        var unlockingScriptData = Data()
        unlockingScriptData.append(UInt8(signature.count + 1))
        unlockingScriptData.append(signature)
        unlockingScriptData.append(UInt8(hashType.rawValue))
        return BitcoinScript(data: unlockingScriptData)
    }

    public enum Error: LocalizedError {
        case invalidOutputScript
        case missingRedeemScript
    }
}
