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

    func testRedeemScriptWrong() {
        let data = Data(hexString: "042de45bea3dada528eee8a1e04142d3e04fad66119d971b6019b0e3c02266b79142158aa83469db1332a880a2d5f8ce0b3bba542b3e32df0740ccbfb01c275e42")!
        let redeemHash = Crypto.sha256ripemd160(data)
        XCTAssertEqual(redeemHash.hexString, "cf5007e19af3641199f21f3fa54dff2fa2627471")
    }

    func testRedeemScript() {
        let publicKey = PublicKey(data: Data(hexString: "042de45bea3dada528eee8a1e04142d3e04fad66119d971b6019b0e3c02266b79142158aa83469db1332a880a2d5f8ce0b3bba542b3e32df0740ccbfb01c275e42")!)!
        let address = publicKey.bitcoinAddress(prefix: 0x05)
        XCTAssertEqual(address.description, "3LbBftXPhBmByAqgpZqx61ttiFfxjde2z7")

        let embeddedScript = BitcoinScript.buildPayToPublicKeyHash(address: address)
        let script = BitcoinScript.buildPayToScriptHash(script: embeddedScript)
        XCTAssertEqual(script.data.hexString, "a914c470d22e69a2a967f2cec0cd5a5aebb955cdd39587")
    }

    func testSpendP2SHTx() throws {
        // from Trust: try account.privateKey(password: password)
        let privateKey = PrivateKey(data: Data(hexString: "65faa535a38572a9ec5440c393808eada67835eadd6c7ea3f1f31b5c5d36c446")!)!
        let toAddress = BitcoinAddress(string: "18eqGohuqvrZLL3LMR4Wv81qvKeDHsGpjH")!
        let changeAddress = BitcoinAddress(string: "3LbBftXPhBmByAqgpZqx61ttiFfxjde2z7")!
        let scriptHash = Data(hexString: "cf5007e19af3641199f21f3fa54dff2fa2627471")!
        XCTAssertEqual(privateKey.publicKey().bitcoinAddress(prefix: 0x05), changeAddress)

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
