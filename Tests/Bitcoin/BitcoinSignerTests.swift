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
        let sighash = tx.getSignatureHash(scriptCode: utxo.output.script, index: 0, hashType: [.all, .fork], amount: utxo.output.value, version: .witnessV0)
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
        let signer = BitcoinTransactionSigner(keyProvider: provider, transaction: unsignedTx)
        let signedTx = try signer.sign([utxo])

        var serialized = Data()
        signedTx.encode(into: &serialized)

        XCTAssertEqual(signedTx.identifier, "b07970ad5ce836d01f7d44362f32fa265bf8267ed587255a9b057e34427c2546")
        XCTAssertEqual(serialized.hexString, "0100000001e28c2b955293159898e34c6840d99bf4d390e2ee1c6f606939f18ee1e2000d05020000006b483045022100c0c5a08d0f4382b962895c601a140143588ad700ebfee987712b6125e7c275cb02204145cb6043131c830eaf69192bc3e68e26b46131f9b6fc0fa880c29f98423b2b4121038eab72ec78e639d02758e7860cdec018b49498c307791f785aa3019622f4ea5bffffffff0258020000000000001976a914769bdff96a02f9135a1d19b749db6a78fe07dc9088ace5100000000000001976a9149e089b6889e032d46e3b915a3392edfd616fb1c488ac00000000")
    }

    func testSignP2WPKH() throws {
        let script = BitcoinScript(data: Data(hexString: "76a9141d0f172a0ecb48aee1be1f2687d2963ae33f71a188ac")!)

        let unspentOutput0 = BitcoinTransactionOutput(value: 625_000_000, script: BitcoinScript(data: Data(hexString: "2103c9f4836b9a4f77fc0d81f7bcb01b7f1b35916864b9476c241ce9fc198bd25432ac")!))
        let unspentOutpoint0 = BitcoinOutPoint(hash: Data(hexString: "fff7f7881a8099afa6940d42d1e7f6362bec38171ea3edf433541db4e4ad969f")!, index: 0)
        let utxo0 = BitcoinUnspentTransaction(output: unspentOutput0, outpoint: unspentOutpoint0)
        let utxoKey0 = PrivateKey(data: Data(hexString: "bbc27228ddcb9209d7fd6f36b02f7dfa6252af40bb2f1cbc7a557da8027ff866")!)!
        let input0 = BitcoinTransactionInput(previousOutput: unspentOutpoint0, script: BitcoinScript(), sequence: 0xffffffee)

        let unspentOutput1 = BitcoinTransactionOutput(value: 600_000_000, script: BitcoinScript(data: Data(hexString: "00141d0f172a0ecb48aee1be1f2687d2963ae33f71a1")!))
        let unspentOutpoint1 = BitcoinOutPoint(hash: Data(hexString: "ef51e1b804cc89d182d279655c3aa89e815b1b309fe287d9b2b55d57b90ec68a")!, index: 1)
        let utxo1 = BitcoinUnspentTransaction(output: unspentOutput1, outpoint: unspentOutpoint1)
        let utxoKey1 = PrivateKey(data: Data(hexString: "619c335025c7f4012e556c2a58b2506e30b8511b53ade95ea316fd8c3286feb9")!)!
        let input1 = BitcoinTransactionInput(previousOutput: unspentOutpoint1, script: BitcoinScript(), sequence: UInt32.max)

        let toOutput = BitcoinTransactionOutput(value: 112_340_000, script: BitcoinScript(data: Data(hexString: "76a9148280b37df378db99f66f85c95a783a76ac7a6d5988ac")!))
        let changeOutput = BitcoinTransactionOutput(value: 223_450_000, script: BitcoinScript(data: Data(hexString: "76a9143bde42dbee7e4dbe6a21b2d50ce2f0167faa815988ac")!))

        let unsignedTx = BitcoinTransaction(version: 1, inputs: [input0, input1], outputs: [toOutput, changeOutput], lockTime: 0x11)

        var unsignedData = Data()
        unsignedTx.encode(into: &unsignedData)
        XCTAssertEqual(unsignedData.hexString, "0100000002fff7f7881a8099afa6940d42d1e7f6362bec38171ea3edf433541db4e4ad969f0000000000eeffffffef51e1b804cc89d182d279655c3aa89e815b1b309fe287d9b2b55d57b90ec68a0100000000ffffffff02202cb206000000001976a9148280b37df378db99f66f85c95a783a76ac7a6d5988ac9093510d000000001976a9143bde42dbee7e4dbe6a21b2d50ce2f0167faa815988ac11000000")

        let provider = BitcoinDefaultPrivateKeyProvider(keys: [utxoKey0, utxoKey1])
        provider.scriptsByScriptHash = [
            Data(hexString: "1d0f172a0ecb48aee1be1f2687d2963ae33f71a1")!: script,
        ]

        let signer = BitcoinTransactionSigner(keyProvider: provider, transaction: unsignedTx, hashType: .all)
        let signedTx = try signer.sign([utxo0, utxo1])

        var serialized = Data()
        signedTx.encode(into: &serialized)

        XCTAssertEqual(signedTx.identifier, "c36c38370907df2324d9ce9d149d191192f338b37665a82e78e76a12c909b762")
        XCTAssertEqual(serialized.hexString, "01000000000102fff7f7881a8099afa6940d42d1e7f6362bec38171ea3edf433541db4e4ad969f00000000494830450221008b9d1dc26ba6a9cb62127b02742fa9d754cd3bebf337f7a55d114c8e5cdd30be022040529b194ba3f9281a99f2b1c0a19c0489bc22ede944ccf4ecbab4cc618ef3ed01eeffffffef51e1b804cc89d182d279655c3aa89e815b1b309fe287d9b2b55d57b90ec68a0100000000ffffffff02202cb206000000001976a9148280b37df378db99f66f85c95a783a76ac7a6d5988ac9093510d000000001976a9143bde42dbee7e4dbe6a21b2d50ce2f0167faa815988ac000247304402203609e17b84f6a7d30c80bfa610b5b4542f32a8a0d5447a12fb1366d7f01cc44a0220573a954c4518331561406f90300e8f3358f51928d43c212a8caed02de67eebee0121025476c2e83188368da1ff3e292e7acafcdb3566bb0ad253f62fc70f07aeee635711000000")
    }

    func testSignP2WSH() throws {
        let script = BitcoinScript(data: Data(hexString: "2103596d3451025c19dbbdeb932d6bf8bfb4ad499b95b6f88db8899efac102e5fc71ac")!)

        let unspentOutput0 = BitcoinTransactionOutput(value: 1000, script: BitcoinScript(data: Data(hexString: "0020ff25429251b5a84f452230a3c75fd886b7fc5a7865ce4a7bb7a9d7c5be6da3db")!))
        let unspentOutpoint0 = BitcoinOutPoint(hash: Data(hexString: "0001000000000000000000000000000000000000000000000000000000000000")!, index: 0)
        let utxo0 = BitcoinUnspentTransaction(output: unspentOutput0, outpoint: unspentOutpoint0)
        let utxoKey0 = PrivateKey(wif: "L5AQtV2HDm4xGsseLokK2VAT2EtYKcTm3c7HwqnJBFt9LdaQULsM")!
        let input0 = BitcoinTransactionInput(previousOutput: unspentOutpoint0, script: BitcoinScript(), sequence: UInt32.max)

        let toOutput = BitcoinTransactionOutput(value: 1000, script: BitcoinScript(data: Data(hexString: "76a9144c9c3dfac4207d5d8cb89df5722cb3d712385e3f88ac")!))

        let unsignedTx = BitcoinTransaction(version: 1, inputs: [input0], outputs: [toOutput], lockTime: 0)

        var unsignedData = Data()
        unsignedTx.encode(into: &unsignedData)
        XCTAssertEqual(unsignedData.hexString, "010000000100010000000000000000000000000000000000000000000000000000000000000000000000ffffffff01e8030000000000001976a9144c9c3dfac4207d5d8cb89df5722cb3d712385e3f88ac00000000")

        let provider = BitcoinDefaultPrivateKeyProvider(keys: [utxoKey0])
        provider.keysByScriptHash = [
            Data(hexString: "593128f9f90e38b706c18623151e37d2da05c229")!: utxoKey0,
        ]
        provider.scriptsByScriptHash = [
            Data(hexString: "593128f9f90e38b706c18623151e37d2da05c229")!: script,
        ]

        let signer = BitcoinTransactionSigner(keyProvider: provider, transaction: unsignedTx, hashType: .all)
        let signedTx = try signer.sign([utxo0])

        var serialized = Data()
        signedTx.encode(into: &serialized)

        XCTAssertEqual(signedTx.identifier, "0df178d21afc9e8a46195c7c2e328aafd8544a1dbd67cf983214cad401966cf3")
        XCTAssertEqual(serialized.hexString, "0100000000010100010000000000000000000000000000000000000000000000000000000000000000000000ffffffff01e8030000000000001976a9144c9c3dfac4207d5d8cb89df5722cb3d712385e3f88ac02483045022100aa5d8aa40a90f23ce2c3d11bc845ca4a12acd99cbea37de6b9f6d86edebba8cb022022dedc2aa0a255f74d04c0b76ece2d7c691f9dd11a64a8ac49f62a99c3a05f9d01232103596d3451025c19dbbdeb932d6bf8bfb4ad499b95b6f88db8899efac102e5fc71ac00000000")
    }

    func testSignP2SH_P2WPKH() throws {
        let redeemScript = BitcoinScript(data: Data(hexString: "001479091972186c449eb1ded22b78e40d009bdf0089")!)
        let scripthash = Crypto.sha256ripemd160(redeemScript.data)

        let unspentOutput0 = BitcoinTransactionOutput(value: 1000_000_000, script: BitcoinScript(data: Data(hexString: "a9144733f37cf4db86fbc2efed2500b4f4e49f31202387")!))
        let unspentOutpoint0 = BitcoinOutPoint(hash: Data(hexString: "db6b1b20aa0fd7b23880be2ecbd4a98130974cf4748fb66092ac4d3ceb1a5477")!, index: 1)
        let utxo0 = BitcoinUnspentTransaction(output: unspentOutput0, outpoint: unspentOutpoint0)
        let utxoKey0 = PrivateKey(data: Data(hexString: "eb696a065ef48a2192da5b28b694f87544b30fae8327c4510137a922f32c6dcf")!)!
        let input0 = BitcoinTransactionInput(previousOutput: unspentOutpoint0, script: BitcoinScript(), sequence: 0xfffffffe)

        let toOutput = BitcoinTransactionOutput(value: 199_996_600, script: BitcoinScript(data: Data(hexString: "76a914a457b684d7f0d539a46a45bbc043f35b59d0d96388ac")!))
        let changeOutput = BitcoinTransactionOutput(value: 800_000_000, script: BitcoinScript(data: Data(hexString: "76a914fd270b1ee6abcaea97fea7ad0402e8bd8ad6d77c88ac")!))

        let unsignedTx = BitcoinTransaction(version: 1, inputs: [input0], outputs: [toOutput, changeOutput], lockTime: 0x492)

        var unsignedData = Data()
        unsignedTx.encode(into: &unsignedData)
        XCTAssertEqual(unsignedData.hexString, "0100000001db6b1b20aa0fd7b23880be2ecbd4a98130974cf4748fb66092ac4d3ceb1a54770100000000feffffff02b8b4eb0b000000001976a914a457b684d7f0d539a46a45bbc043f35b59d0d96388ac0008af2f000000001976a914fd270b1ee6abcaea97fea7ad0402e8bd8ad6d77c88ac92040000")

        let provider = BitcoinDefaultPrivateKeyProvider(keys: [utxoKey0])
        provider.keysByScriptHash = [
            scripthash: utxoKey0,
        ]
        provider.scriptsByScriptHash = [
            scripthash: redeemScript,
        ]

        let signer = BitcoinTransactionSigner(keyProvider: provider, transaction: unsignedTx, hashType: .all)
        let signedTx = try signer.sign([utxo0])

        var serialized = Data()
        signedTx.encode(into: &serialized)

        XCTAssertEqual(signedTx.identifier, "680f483b2bf6c5dcbf111e69e885ba248a41a5e92070cfb0afec3cfc49a9fabb")
        XCTAssertEqual(serialized.hexString, "01000000000101db6b1b20aa0fd7b23880be2ecbd4a98130974cf4748fb66092ac4d3ceb1a5477010000001716001479091972186c449eb1ded22b78e40d009bdf0089feffffff02b8b4eb0b000000001976a914a457b684d7f0d539a46a45bbc043f35b59d0d96388ac0008af2f000000001976a914fd270b1ee6abcaea97fea7ad0402e8bd8ad6d77c88ac02473044022047ac8e878352d3ebbde1c94ce3a10d057c24175747116f8288e5d794d12d482f0220217f36a485cae903c713331d877c1f64677e3622ad4010726870540656fe9dcb012103ad1d8e89212f0b92c74d23bb710c00662ad1470198ac48c43f7d6f93a2a2687392040000")
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

    func createUnsignedTx(toAddress: BitcoinAddress, amount: Int64, changeAddress: BitcoinAddress, utxos: [BitcoinUnspentTransaction], publicKey: PublicKey? = nil, fee: Int64 = 226) -> BitcoinTransaction {
        let totalAmount: Int64 = utxos.reduce(0) { $0 + $1.output.value }
        let change: Int64 = totalAmount - amount - fee

        let lockingScriptTo = BitcoinScript.buildPayToPublicKeyHash(address: toAddress)
        let lockingScriptChange = BitcoinScript.buildPayToPublicKeyHash(address: changeAddress)

        let toOutput = BitcoinTransactionOutput(value: amount, script: lockingScriptTo)
        let changeOutput = BitcoinTransactionOutput(value: change, script: lockingScriptChange)

        let unsignedInputs = utxos.map { BitcoinTransactionInput(previousOutput: $0.outpoint, script: BitcoinScript(), sequence: UInt32.max) }
        return BitcoinTransaction(version: 1, inputs: unsignedInputs, outputs: [toOutput, changeOutput], lockTime: 0)
    }
}
