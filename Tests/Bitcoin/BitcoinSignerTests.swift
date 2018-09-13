// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

@testable import TrustCore
import XCTest

// swiftlint:disable line_length

class BitcoinSignerTests: XCTestCase {
    func testSignHash() {
        let toAddress = BitcoinAddress(string: "1Bp9U1ogV3A14FMvKbRJms7ctyso4Z4Tcx")!
        let changeAddress = BitcoinAddress(string: "1FQc5LdgGHMHEN9nwkjmz6tWkxhPpxBvBU")!
        let unspentOutput = BitcoinTransactionOutput(value: 5151, script: BitcoinScript(data: Data(hexString: "76a914aff1e0789e5fe316b729577665aa0a04d5b0f8c788ac")!))
        let unspentOutpoint = BitcoinOutPoint(hash: Data(hexString: "e28c2b955293159898e34c6840d99bf4d390e2ee1c6f606939f18ee1e2000d05")!, index: 2)
        let utxo = BitcoinUnspentTransaction(output: unspentOutput, outpoint: unspentOutpoint)
        let tx = createUnsignedTx(toAddress: toAddress, amount: 600, changeAddress: changeAddress, utxos: [utxo])
        let sighash = tx.getSignatureHash(scriptCode: utxo.output.script, index: 0, hashType: [.all, .fork], amount: utxo.output.value)
        XCTAssertEqual(sighash.hexString, "1136d4975aee4ff6ccf0b8a9c640532f563b48d9856fdc9682c37a071702937c")
    }

    func testSignTransaction() throws {
        let toAddress = BitcoinAddress(string: "1Bp9U1ogV3A14FMvKbRJms7ctyso4Z4Tcx")!
        let changeAddress = BitcoinAddress(string: "1FQc5LdgGHMHEN9nwkjmz6tWkxhPpxBvBU")!

        let unspentOutput = BitcoinTransactionOutput(value: 5151, script: BitcoinScript(data: Data(hexString: "76a914aff1e0789e5fe316b729577665aa0a04d5b0f8c788ac")!))
        let unspentOutpoint = BitcoinOutPoint(hash: Data(hexString: "e28c2b955293159898e34c6840d99bf4d390e2ee1c6f606939f18ee1e2000d05")!, index: 2)
        let utxo = BitcoinUnspentTransaction(output: unspentOutput, outpoint: unspentOutpoint)
        let utxoKey = PrivateKey(wif: "L1WFAgk5LxC5NLfuTeADvJ5nm3ooV3cKei5Yi9LJ8ENDfGMBZjdW")!
        let provider = BitcoinDefaultPrivateKeyProvider(keys: [utxoKey])

        let unsignedTx = createUnsignedTx(toAddress: toAddress, amount: 600, changeAddress: changeAddress, utxos: [utxo])
        let signer = BitcoinTransactionSigner(keyProvider: provider)
        let signedTx = try signer.sign(unsignedTx, utxos: [utxo])

        var serialized = Data()
        signedTx.encode(into: &serialized)

        XCTAssertEqual(signedTx.identifier, "96ee20002b34e468f9d3c5ee54f6a8ddaa61c118889c4f35395c2cd93ba5bbb4")
        XCTAssertEqual(serialized.hexString, "0100000001e28c2b955293159898e34c6840d99bf4d390e2ee1c6f606939f18ee1e2000d05020000006b483045022100b70d158b43cbcded60e6977e93f9a84966bc0cec6f2dfd1463d1223a90563f0d02207548d081069de570a494d0967ba388ff02641d91cadb060587ead95a98d4e3534121038eab72ec78e639d02758e7860cdec018b49498c307791f785aa3019622f4ea5bffffffff0258020000000000001976a914769bdff96a02f9135a1d19b749db6a78fe07dc9088ace5100000000000001976a9149e089b6889e032d46e3b915a3392edfd616fb1c488ac00000000")
    }

    func testSignP2WPKH() throws {
        let unspentOutput0 = BitcoinTransactionOutput(value: 625000, script: BitcoinScript(data: Data(hexString: "2103c9f4836b9a4f77fc0d81f7bcb01b7f1b35916864b9476c241ce9fc198bd25432ac")!))
        let unspentOutpoint0 = BitcoinOutPoint(hash: Data(hexString: "fff7f7881a8099afa6940d42d1e7f6362bec38171ea3edf433541db4e4ad969f")!, index: 0)
        let utxo0 = BitcoinUnspentTransaction(output: unspentOutput0, outpoint: unspentOutpoint0)
        let utxoKey0 = PrivateKey(data: Data(hexString: "bbc27228ddcb9209d7fd6f36b02f7dfa6252af40bb2f1cbc7a557da8027ff866")!)!
        let input0 = BitcoinTransactionInput(previousOutput: unspentOutpoint0, script: BitcoinScript(), sequence: 0xffffffee)

        let unspentOutput1 = BitcoinTransactionOutput(value: 600000, script: BitcoinScript(data: Data(hexString: "00141d0f172a0ecb48aee1be1f2687d2963ae33f71a1")!))
        let unspentOutpoint1 = BitcoinOutPoint(hash: Data(hexString: "ef51e1b804cc89d182d279655c3aa89e815b1b309fe287d9b2b55d57b90ec68a")!, index: 1)
        let utxo1 = BitcoinUnspentTransaction(output: unspentOutput1, outpoint: unspentOutpoint1)
        let utxoKey1 = PrivateKey(data: Data(hexString: "619c335025c7f4012e556c2a58b2506e30b8511b53ade95ea316fd8c3286feb9")!)!
        let input1 = BitcoinTransactionInput(previousOutput: unspentOutpoint1, script: BitcoinScript(), sequence: UInt32.max)

        let toOutput = BitcoinTransactionOutput(value: 112340000, script: BitcoinScript(data: Data(hexString: "76a9148280b37df378db99f66f85c95a783a76ac7a6d5988ac")!))
        let changeOutput = BitcoinTransactionOutput(value: 223450000, script: BitcoinScript(data: Data(hexString: "76a9143bde42dbee7e4dbe6a21b2d50ce2f0167faa815988ac")!))

        var unsignedTx = BitcoinTransaction(version: 1, inputs: [input0, input1], outputs: [toOutput, changeOutput], lockTime: 0)
        unsignedTx.lockTime = 0x11

        var unsignedData = Data()
        unsignedTx.encode(into: &unsignedData)
        XCTAssertEqual(unsignedData.hexString, "0100000002fff7f7881a8099afa6940d42d1e7f6362bec38171ea3edf433541db4e4ad969f0000000000eeffffffef51e1b804cc89d182d279655c3aa89e815b1b309fe287d9b2b55d57b90ec68a0100000000ffffffff02202cb206000000001976a9148280b37df378db99f66f85c95a783a76ac7a6d5988ac9093510d000000001976a9143bde42dbee7e4dbe6a21b2d50ce2f0167faa815988ac11000000")

        let provider = BitcoinDefaultPrivateKeyProvider(keys: [utxoKey0])
        provider.keysByScriptHash = [
            Data(hexString: "1d0f172a0ecb48aee1be1f2687d2963ae33f71a1")!: utxoKey1,
        ]

        let signer = BitcoinTransactionSigner(keyProvider: provider)
        let signedTx = try signer.sign(unsignedTx, utxos: [utxo0, utxo1], hashType: .all)

        var serialized = Data()
        signedTx.encode(into: &serialized)

        XCTAssertEqual(signedTx.identifier, "c37af31116d1b27caf68aae9e3ac82f1477929014d5b917657d0eb49478cb670")
        XCTAssertEqual(serialized.hexString, "01000000000102fff7f7881a8099afa6940d42d1e7f6362bec38171ea3edf433541db4e4ad969f00000000494830450221008b9d1dc26ba6a9cb62127b02742fa9d754cd3bebf337f7a55d114c8e5cdd30be022040529b194ba3f9281a99f2b1c0a19c0489bc22ede944ccf4ecbab4cc618ef3ed01eeffffffef51e1b804cc89d182d279655c3aa89e815b1b309fe287d9b2b55d57b90ec68a0100000000ffffffff02202cb206000000001976a9148280b37df378db99f66f85c95a783a76ac7a6d5988ac9093510d000000001976a9143bde42dbee7e4dbe6a21b2d50ce2f0167faa815988ac000247304402203609e17b84f6a7d30c80bfa610b5b4542f32a8a0d5447a12fb1366d7f01cc44a0220573a954c4518331561406f90300e8f3358f51928d43c212a8caed02de67eebee0121025476c2e83188368da1ff3e292e7acafcdb3566bb0ad253f62fc70f07aeee635711000000")
    }

    func testRedeemScriptWrong() {
        let data = Data(hexString: "042de45bea3dada528eee8a1e04142d3e04fad66119d971b6019b0e3c02266b79142158aa83469db1332a880a2d5f8ce0b3bba542b3e32df0740ccbfb01c275e42")!
        let redeemHash = Crypto.sha256ripemd160(data)
        XCTAssertEqual(redeemHash.hexString, "cf5007e19af3641199f21f3fa54dff2fa2627471")
    }

    func testRedeemScript() {
        let publicKey = PublicKey(data: Data(hexString: "042de45bea3dada528eee8a1e04142d3e04fad66119d971b6019b0e3c02266b79142158aa83469db1332a880a2d5f8ce0b3bba542b3e32df0740ccbfb01c275e42")!)!
        let address = publicKey.legacyBitcoinAddress(prefix: 0x05)
        XCTAssertEqual(address.description, "3LbBftXPhBmByAqgpZqx61ttiFfxjde2z7")

        let embeddedScript = BitcoinScript.buildPayToPublicKeyHash(address: address)
        let script = BitcoinScript.buildPayToScriptHash(script: embeddedScript)
        XCTAssertEqual(script.data.hexString, "a914c470d22e69a2a967f2cec0cd5a5aebb955cdd39587")
    }

    func testSpendP2SHTx() throws {
        let privateKey = PrivateKey(data: Data(hexString: "65faa535a38572a9ec5440c393808eada67835eadd6c7ea3f1f31b5c5d36c446")!)!
        let toAddress = BitcoinAddress(string: "18eqGohuqvrZLL3LMR4Wv81qvKeDHsGpjH")!
        let changeAddress = BitcoinAddress(string: "3LbBftXPhBmByAqgpZqx61ttiFfxjde2z7")!
        let scriptHash = Data(hexString: "cf5007e19af3641199f21f3fa54dff2fa2627471")!
        XCTAssertEqual(privateKey.publicKey().legacyBitcoinAddress(prefix: 0x05), changeAddress)

        // UTXO info: https://btc-rpc.binancechain.io/insight-api/addr/3LbBftXPhBmByAqgpZqx61ttiFfxjde2z7/utxo
        let unspentOutput = BitcoinTransactionOutput(value: 50000, script: BitcoinScript.buildPayToScriptHash(scriptHash: scriptHash))
        let unspentOutpoint = BitcoinOutPoint(hash: Data(hexString: "8c0923047ab47e449dd3f01d78bcdd4a0cb767e89a2007f70c095b40d3569c01")!, index: 1)
        let utxo = BitcoinUnspentTransaction(output: unspentOutput, outpoint: unspentOutpoint)
        let provider = BitcoinDefaultPrivateKeyProvider(keys: [privateKey])
        provider.keysByScriptHash = [
            scriptHash: privateKey,
        ]
        provider.scriptsByScriptHash = [
            scriptHash: BitcoinScript.buildSegWit(address: changeAddress),
        ]

        let unsignedTx = createUnsignedTx(toAddress: toAddress, amount: 20000, changeAddress: changeAddress, utxos: [utxo], publicKey: privateKey.publicKey(), fee: 904)

        var unsignedSerialized = Data()
        unsignedTx.encode(into: &unsignedSerialized)

        let signer = BitcoinTransactionSigner(keyProvider: provider)
        let signedTx = try signer.sign(unsignedTx, utxos: [utxo])

        var serialized = Data()
        signedTx.encode(into: &serialized)

        // get error: {"code": -25, "message": "Missing inputs"} when broadcasting this tx
        // http://chainquery.com/bitcoin-api/sendrawtransaction
        XCTAssertEqual(serialized.hexString, "01000000018c0923047ab47e449dd3f01d78bcdd4a0cb767e89a2007f70c095b40d3569c01010000005f47304402207ac20ebe315a4254bae98aae0500c35023dd31397522aafa531313159a4a338402201114c0381e3b1e773e513d861e0665b627f237d822e7ad99d56fc9f05dda0c7141160014cf5007e19af3641199f21f3fa54dff2fa2627471ffffffff02204e0000000000001976a91453f0912255fb6f2ea3962d5d1945963d2a8c861e88aca87100000000000017a914c470d22e69a2a967f2cec0cd5a5aebb955cdd3958700000000")
    }

    func createUnsignedTx(toAddress: BitcoinAddress, amount: Int64, changeAddress: BitcoinAddress, utxos: [BitcoinUnspentTransaction], publicKey: PublicKey? = nil, fee: Int64 = 226) -> BitcoinTransaction {
        let totalAmount: Int64 = utxos.reduce(0) { $0 + $1.output.value }
        let change: Int64 = totalAmount - amount - fee

        let lockingScriptTo = BitcoinScript.buildPayToPublicKeyHash(address: toAddress)
        var lockingScriptChange = BitcoinScript.buildPayToPublicKeyHash(address: changeAddress)
        if changeAddress.base58String.starts(with: "3") {
            lockingScriptChange = BitcoinScript.buildPayToScriptHash(script: lockingScriptChange)
        }

        let toOutput = BitcoinTransactionOutput(value: amount, script: lockingScriptTo)
        let changeOutput = BitcoinTransactionOutput(value: change, script: lockingScriptChange)

        let unsignedInputs = utxos.map { BitcoinTransactionInput(previousOutput: $0.outpoint, script: BitcoinScript(), sequence: UInt32.max) }
        return BitcoinTransaction(version: 1, inputs: unsignedInputs, outputs: [toOutput, changeOutput], lockTime: 0)
    }
}
