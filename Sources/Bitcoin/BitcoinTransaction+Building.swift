// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public extension BitcoinTransaction {
    static func build(to: Address, amount: Int64, fee: Int64, changeAddress: Address, utxos: [BitcoinUnspentTransaction]) -> BitcoinTransaction {

        let totalAmount: Int64 = utxos.reduce(0) { $0 + $1.output.value }
        let change: Int64 = totalAmount - amount - fee

        let lockingScriptTo = BitcoinScript.buildScript(for: to)!
        let toOutput = BitcoinTransactionOutput(value: amount, script: lockingScriptTo)

        var outputs = [toOutput]

        if change > 0 {
            let lockingScriptChange = BitcoinScript.buildScript(for: changeAddress)!
            let changeOutput = BitcoinTransactionOutput(value: change, script: lockingScriptChange)
            outputs.append(changeOutput)
        }

        let unsignedInputs = utxos.map { BitcoinTransactionInput(previousOutput: $0.outpoint, script: BitcoinScript(), sequence: UInt32.max) }
        return BitcoinTransaction(version: 1, inputs: unsignedInputs, outputs: outputs, lockTime: 0)
    }
}

public extension BitcoinScript {
    static func buildScript(for address: Address) -> BitcoinScript? {
        let bitcoin = Bitcoin()
        let bitcoinTestNet = BitcoinTestNet()

        if let bitcoinAddress = address as? BitcoinAddress {
            if bitcoinAddress.data[0] == bitcoin.p2pkhPrefix || bitcoinAddress.data[0] == bitcoinTestNet.p2pkhPrefix {
                // address starts with 1(main net) or m (test net)
                return BitcoinScript.buildPayToPublicKeyHash(address: bitcoinAddress)
            } else if bitcoinAddress.data[0] == bitcoin.p2shPrefix || bitcoinAddress.data[0] == bitcoinTestNet.p2shPrefix{
                // address starts with 3(main net) or 2(test net)
                return BitcoinScript.buildPayToScriptHash(bitcoinAddress.data.dropFirst())
            }
        } else if let segwitAddress = address as? BitcoinSegwitAddress {
            // address starts with bc
            let witness = WitnessProgram.from(bech32: segwitAddress.data)!
            if witness.program.count == 20 {
                return BitcoinScript.buildPayToWitnessPubkeyHash(witness.program)
            }else if witness.program.count == 32 {
                return BitcoinScript.buildPayToWitnessScriptHash(witness.program)
            }
        } else if let segwitAddress = address as? BitcoinTestNetSegwitAddress {
            // address starts with tb
            let witness = WitnessProgram.from(bech32: segwitAddress.data)!
            if witness.program.count == 20 {
                return BitcoinScript.buildPayToWitnessPubkeyHash(witness.program)
            }else if witness.program.count == 32 {
                return BitcoinScript.buildPayToWitnessScriptHash(witness.program)
            }
        }
        return nil
    }
}
