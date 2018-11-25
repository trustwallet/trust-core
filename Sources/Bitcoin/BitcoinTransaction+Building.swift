// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

enum BitcoinTransactionError: LocalizedError {
    case invalidScript
}

public extension BitcoinTransaction {
    static func build(to: Address, amount: Int64, fee: Int64, changeAddress: Address, utxos: [BitcoinUnspentTransaction]) throws -> BitcoinTransaction {

        let bitcoin = Bitcoin()
        let totalAmount: Int64 = utxos.reduce(0) { $0 + $1.output.value }
        let change: Int64 = totalAmount - amount - fee

        guard let lockingScriptTo = bitcoin.buildScript(for: to) else {
            throw BitcoinTransactionError.invalidScript
        }
        let toOutput = BitcoinTransactionOutput(value: amount, script: lockingScriptTo)
        var outputs = [toOutput]

        if change > 0 {
            let lockingScriptChange = bitcoin.buildScript(for: changeAddress)!
            let changeOutput = BitcoinTransactionOutput(value: change, script: lockingScriptChange)
            outputs.append(changeOutput)
        }

        let unsignedInputs = utxos.map { BitcoinTransactionInput(previousOutput: $0.outpoint, script: BitcoinScript(), sequence: UInt32.max) }
        return BitcoinTransaction(version: 1, inputs: unsignedInputs, outputs: outputs, lockTime: 0)
    }
}

public extension Bitcoin {
    func buildScript(for address: Address) -> BitcoinScript? {
        if let bitcoinAddress = address as? BitcoinAddress {
            if bitcoinAddress.data[0] == self.p2pkhPrefix {
                // address starts with 1/L
                return BitcoinScript.buildPayToPublicKeyHash(bitcoinAddress.data.dropFirst())
            } else if bitcoinAddress.data[0] == self.p2shPrefix {
                // address starts with 3/M
                guard supportSegwit else {
                    // bch doesn't support segwit and we don't support multi sig in the app
                    // google: bitcoin cash stuck segwit
                    return nil
                }
                return BitcoinScript.buildPayToScriptHash(bitcoinAddress.data.dropFirst())
            }
        } else if let bech32Address = address as? BitcoinBech32Address {
            // address starts with bc/ltc
            let program = WitnessProgram.from(bech32: bech32Address.data)!
            return BitcoinScript.buildPayToWitnessPubkeyHash(program.program)
        } else if let cashAddress = address as? BitcoinCashAddress {
            let bitcoinAddress = cashAddress.toBitcoinAddress()
            return self.buildScript(for: bitcoinAddress)
        }
        return nil
    }
}
