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

        let signer = BitcoinTransactionSigner(keyProvider: provider)
        let signedTx = try signer.sign(unsignedTx, utxos: [utxo0, utxo1], hashType: .all)

        var serialized = Data()
        signedTx.encode(into: &serialized)

        XCTAssertEqual(signedTx.identifier, "c36c38370907df2324d9ce9d149d191192f338b37665a82e78e76a12c909b762")
        XCTAssertEqual(serialized.hexString, "01000000000102fff7f7881a8099afa6940d42d1e7f6362bec38171ea3edf433541db4e4ad969f00000000494830450221008b9d1dc26ba6a9cb62127b02742fa9d754cd3bebf337f7a55d114c8e5cdd30be022040529b194ba3f9281a99f2b1c0a19c0489bc22ede944ccf4ecbab4cc618ef3ed01eeffffffef51e1b804cc89d182d279655c3aa89e815b1b309fe287d9b2b55d57b90ec68a0100000000ffffffff02202cb206000000001976a9148280b37df378db99f66f85c95a783a76ac7a6d5988ac9093510d000000001976a9143bde42dbee7e4dbe6a21b2d50ce2f0167faa815988ac000247304402203609e17b84f6a7d30c80bfa610b5b4542f32a8a0d5447a12fb1366d7f01cc44a0220573a954c4518331561406f90300e8f3358f51928d43c212a8caed02de67eebee0121025476c2e83188368da1ff3e292e7acafcdb3566bb0ad253f62fc70f07aeee635711000000")
    }

    func testSignP2WSH() throws {
        let script = BitcoinScript(data: Data(hexString: "21026dccc749adc2a9d0d89497ac511f760f45c47dc5ed9cf352a58ac706453880aeadab210255a9626aebf5e29c0e6538428ba0d1dcf6ca98ffdf086aa8ced5e0d0215ea465ac")!)

        let unspentOutput0 = BitcoinTransactionOutput(value: 156_250_000, script: BitcoinScript(data: Data(hexString: "21036d5c20fa14fb2f635474c1dc4ef5909d4568e5569b79fc94d3448486e14685f8ac")!))
        let unspentOutpoint0 = BitcoinOutPoint(hash: Data(hexString: "fe3dc9208094f3ffd12645477b3dc56f60ec4fa8e6f5d67c565d1c6b9216b36e")!, index: 0)
        let utxo0 = BitcoinUnspentTransaction(output: unspentOutput0, outpoint: unspentOutpoint0)
        let utxoKey0 = PrivateKey(data: Data(hexString: "b8f28a772fccbf9b4f58a4f027e07dc2e35e7cd80529975e292ea34f84c4580c")!)!
        let input0 = BitcoinTransactionInput(previousOutput: unspentOutpoint0, script: BitcoinScript(), sequence: UInt32.max)

        let unspentOutput1 = BitcoinTransactionOutput(value: 4_900_000_000, script: BitcoinScript(data: Data(hexString: "00205d1b56b63d714eebe542309525f484b7e9d6f686b3781b6f61ef925d66d6f6a0")!))
        let unspentOutpoint1 = BitcoinOutPoint(hash: Data(hexString: "0815cf020f013ed6cf91d29f4202e8a58726b1ac6c79da47c23d1bee0a6925f8")!, index: 0)
        let utxo1 = BitcoinUnspentTransaction(output: unspentOutput1, outpoint: unspentOutpoint1)
        let utxoKey1 = PrivateKey(data: Data(hexString: "8e02b539b1500aa7c81cf3fed177448a546f19d2be416c0c61ff28e577d8d0cd")!)!
        let input1 = BitcoinTransactionInput(previousOutput: unspentOutpoint1, script: BitcoinScript(), sequence: UInt32.max)

        let toOutput = BitcoinTransactionOutput(value: 5_000_000_000, script: BitcoinScript(data: Data(hexString: "76a914a30741f8145e5acadf23f751864167f32e0963f788ac")!))

        let unsignedTx = BitcoinTransaction(version: 1, inputs: [input0, input1], outputs: [toOutput], lockTime: 0)

        var unsignedData = Data()
        unsignedTx.encode(into: &unsignedData)
        XCTAssertEqual(unsignedData.hexString, "0100000002fe3dc9208094f3ffd12645477b3dc56f60ec4fa8e6f5d67c565d1c6b9216b36e0000000000ffffffff0815cf020f013ed6cf91d29f4202e8a58726b1ac6c79da47c23d1bee0a6925f80000000000ffffffff0100f2052a010000001976a914a30741f8145e5acadf23f751864167f32e0963f788ac00000000")

        let provider = BitcoinDefaultPrivateKeyProvider(keys: [utxoKey0])
        provider.keysByScriptHash = [
            Data(hexString: "5d1b56b63d714eebe542309525f484b7e9d6f686b3781b6f61ef925d66d6f6a0")!: utxoKey1,
        ]
        provider.scriptsByScriptHash = [
            Data(hexString: "5d1b56b63d714eebe542309525f484b7e9d6f686b3781b6f61ef925d66d6f6a0")!: script,
        ]

        let signer = BitcoinTransactionSigner(keyProvider: provider)
        let signedTx = try signer.sign(unsignedTx, utxos: [utxo0, utxo1], hashType: .single)

        var serialized = Data()
        signedTx.encode(into: &serialized)

        //XCTAssertEqual(signedTx.identifier, "c36c38370907df2324d9ce9d149d191192f338b37665a82e78e76a12c909b762")
        //XCTAssertEqual(serialized.hexString, "01000000000102fe3dc9208094f3ffd12645477b3dc56f60ec4fa8e6f5d67c565d1c6b9216b36e000000004847304402200af4e47c9b9629dbecc21f73af989bdaa911f7e6f6c2e9394588a3aa68f81e9902204f3fcf6ade7e5abb1295b6774c8e0abd94ae62217367096bc02ee5e435b67da201ffffffff0815cf020f013ed6cf91d29f4202e8a58726b1ac6c79da47c23d1bee0a6925f80000000000ffffffff0100f2052a010000001976a914a30741f8145e5acadf23f751864167f32e0963f788ac000347304402200de66acf4527789bfda55fc5459e214fa6083f936b430a762c629656216805ac0220396f550692cd347171cbc1ef1f51e15282e837bb2b30860dc77c8f78bc8501e503473044022027dc95ad6b740fe5129e7e62a75dd00f291a2aeb1200b84b09d9e3789406b6c002201a9ecd315dd6a0e632ab20bbb98948bc0c6fb204f2c286963bb48517a7058e27034721026dccc749adc2a9d0d89497ac511f760f45c47dc5ed9cf352a58ac706453880aeadab210255a9626aebf5e29c0e6538428ba0d1dcf6ca98ffdf086aa8ced5e0d0215ea465ac00000000")
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
