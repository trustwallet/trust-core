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
            let key: PrivateKey

            if let pubkeyHash = utxo.output.script.matchPayToPubkeyHash() {
                guard let maybeKey = self.keyProvider.key(forPublicKeyHash: pubkeyHash) else {
                    // Missing key, can't sign
                    continue
                }
                key = maybeKey
            } else if let pubkey = utxo.output.script.matchPayToPubkey() {
                guard let maybeKey = self.keyProvider.key(forPublicKey: pubkey) else {
                    // Missing key, can't sign
                    continue
                }
                key = maybeKey
            } else if let scriptHash = utxo.output.script.matchPayToScriptHash() {
                guard let maybeKey = self.keyProvider.key(forScriptHash: scriptHash) else {
                    // Missing key, can't sign
                    continue
                }
                key = maybeKey
            } else {
                throw Error.invalidOutputScript
            }

            let transactionToSign = BitcoinTransaction(version: unsignedTx.version, inputs: inputsToSign, outputs: unsignedTx.outputs, lockTime: unsignedTx.lockTime)
            let sighash = transactionToSign.getSignatureHash(scriptCode: utxo.output.script, index: i, hashType: hashType, amount: utxo.output.value)
            let signature = key.signAsDER(hash: sighash)
            let txin = inputsToSign[i]
            let pubkey = key.publicKey(compressed: true)

            let script: BitcoinScript
            if let scriptHash = utxo.output.script.matchPayToScriptHash() {
                guard let redeemScript = keyProvider.script(forScriptHash: scriptHash) else {
                    throw Error.missingRedeemScript
                }
                script = unlockingScript(signature: signature, script: redeemScript, hashType: hashType)
            } else {
                script = unlockingScript(signature: signature, publicKey: pubkey, hashType: hashType)
            }

            inputsToSign[i] = BitcoinTransactionInput(previousOutput: txin.previousOutput, script: script, sequence: txin.sequence)
        }

        return BitcoinTransaction(version: unsignedTx.version, inputs: inputsToSign, outputs: unsignedTx.outputs, lockTime: unsignedTx.lockTime)
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

    public enum Error: LocalizedError {
        case invalidOutputScript
        case missingRedeemScript
    }
}
