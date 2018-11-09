// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
@testable import TrustCore

// swiftlint:disable line_length
class BitcoinTestNetSignerTest: XCTestCase {

    func test_P2WSH_in_P2SH_Sig() throws {
        let privateKey = PrivateKey(wif: "Kwi8EArppSCAiMRNNHE9u8HF5p26MzW7U3uoUipyq9xisEAazPaF")!
        let pub = privateKey.publicKey(compressed: true)
        let pubs = [pub, pub]
        let redeemScript = BitcoinScript.buildPayToMultiSigHash((pubs, 1))

        let scripthash = Crypto.sha256ripemd160(redeemScript.data)

        let sha256Hash = Crypto.sha256(redeemScript.data)

        let witnessScript = BitcoinScript.buildPayToWitnessScriptHash(sha256Hash)
        let witnessScriptHash = Crypto.sha256ripemd160(witnessScript.data)

        let address = BitcoinTestNet().multiP2WSHNestedInP2SHAddress((pubs, 1))!
        print(address.description)

        let toAddress =  BitcoinSegwitAddress(string: "tb1qh5l85fp6938unyuk7qhtk452z2lqenm2289l8g")!
        let changeAddress = address

        let addressScript = BitcoinScript.buildScript(for: address)!
        let unspentOutput = BitcoinTransactionOutput(value: 720000, script: addressScript)
        let unspentOutpoint = BitcoinOutPoint(hash: Data(Data(hexString: "c999dc93fd38196c47a9f2de1fc88030f9b47df0cb1bffc4bfcb48caae36f2b2")!.reversed()), index: 1)

        let utxo = BitcoinUnspentTransaction(output: unspentOutput, outpoint: unspentOutpoint)
        let utxoKey = PrivateKey(wif: "Kwi8EArppSCAiMRNNHE9u8HF5p26MzW7U3uoUipyq9xisEAazPaF")!

        let provider = BitcoinDefaultPrivateKeyProvider(keys: [utxoKey])

        provider.scriptsByScriptHash = [
            scripthash: redeemScript,
            witnessScriptHash: witnessScript,
        ]

        let unsignedTx = BitcoinTransaction.build(to: toAddress, amount: 600, fee: 5, changeAddress: changeAddress, utxos: [utxo])
        let signer = BitcoinTransactionSigner(keyProvider: provider, transaction: unsignedTx, hashType: .all)
        let signedTx = try signer.sign([utxo])

        var serialized = Data()
        signedTx.encode(into: &serialized)
        XCTAssertEqual(serialized.hexString, "01000000000101b2f236aeca48cbbfc4ff1bcbf07db4f93080c81fdef2a9476c1938fd93dc99c9010000002322002081bd645a767d68ee6116eb85b5b2597640e4d9f18ef1204f0533dbae7b929be9ffffffff025802000000000000160014bd3e7a243a2c4fc99396f02ebb568a12be0ccf6a23fa0a000000000017a914a84600d08ef29176d48c9e130ffa2450888c5f2b8703004830450221008659daf5e4dfcf24509c84fe59f7857d8cbc779e462048f5bbc7e7217bfc9686022075535a5709c9be7109d154f5367d909d974ea0a14f2f0b017ebe64287e0d18d60147512103334fb58fbad88139aad2b6e34ce42bb65f3a85454c04388a8e770a170f14f9b32103334fb58fbad88139aad2b6e34ce42bb65f3a85454c04388a8e770a170f14f9b352ae00000000")

    }

    func test_P2WSH_Sig() throws {
        let privateKey = PrivateKey(wif: "Kwi8EArppSCAiMRNNHE9u8HF5p26MzW7U3uoUipyq9xisEAazPaF")!
        let pub = privateKey.publicKey(compressed: true)
        let pubs = [pub, pub]
        let redeemScript = BitcoinScript.buildPayToMultiSigHash((pubs, 1))
        let address = BitcoinTestNet().multiP2WSHAddress((pubs, 1))!
        print(address.description)

        let toAddress =  BitcoinSegwitAddress(string: "tb1qh5l85fp6938unyuk7qhtk452z2lqenm2289l8g")!
        let changeAddress = address

        let addressScript = BitcoinScript.buildScript(for: address)!

        let unspentOutput = BitcoinTransactionOutput(value: 720000, script: addressScript)

        let unspentOutpoint = BitcoinOutPoint(hash: Data(Data(hexString: "a9141cb2f7c3c0e1cc595e8bbd007e0dc9c46a654f981d4949e430f74cda4296")!.reversed()), index: 0)
        // big-endian:a9141cb2f7c3c0e1cc595e8bbd007e0dc9c46a654f981d4949e430f74cda4296
        //hash : 9642da4cf730e449491d984f656ac4c90d7e00bd8b5e59cce1c0c3f7b21c14a9
        let utxo = BitcoinUnspentTransaction(output: unspentOutput, outpoint: unspentOutpoint)
        let utxoKey = PrivateKey(wif: "Kwi8EArppSCAiMRNNHE9u8HF5p26MzW7U3uoUipyq9xisEAazPaF")!

        let provider = BitcoinDefaultPrivateKeyProvider(keys: [utxoKey])
        let scripthash = Crypto.sha256ripemd160(redeemScript.data)
        provider.scriptsByScriptHash = [
            scripthash: redeemScript,
        ]

        let unsignedTx = BitcoinTransaction.build(to: toAddress, amount: 600, fee: 5, changeAddress: changeAddress, utxos: [utxo])
        let signer = BitcoinTransactionSigner(keyProvider: provider, transaction: unsignedTx, hashType: .all)
        let signedTx = try signer.sign([utxo])

        var serialized = Data()
        signedTx.encode(into: &serialized)

        XCTAssertEqual(serialized.hexString, "010000000001019642da4cf730e449491d984f656ac4c90d7e00bd8b5e59cce1c0c3f7b21c14a90000000000ffffffff025802000000000000160014bd3e7a243a2c4fc99396f02ebb568a12be0ccf6a23fa0a000000000022002081bd645a767d68ee6116eb85b5b2597640e4d9f18ef1204f0533dbae7b929be903004730440220038d4e50c2b54b5f32f5adfe17d3dbc09458b5cf0582a4e37bb17f9e61f6f2f102207b1ca661619c5128841b20c1795f7e60e276c74c0837031c556a4d9473c805fd0147512103334fb58fbad88139aad2b6e34ce42bb65f3a85454c04388a8e770a170f14f9b32103334fb58fbad88139aad2b6e34ce42bb65f3a85454c04388a8e770a170f14f9b352ae00000000")
    }

    func testMultiSig() throws {

        let privateKey = PrivateKey(wif: "Kwi8EArppSCAiMRNNHE9u8HF5p26MzW7U3uoUipyq9xisEAazPaF")!
        let pub = privateKey.publicKey(compressed: false)

        let pubs = [pub, pub]
        let redeemScript = BitcoinScript.buildPayToMultiSigHash((pubs, 1))
        let scripthash = Crypto.sha256ripemd160(redeemScript.data)

        print(BitcoinTestNet().multiSigAddress((pubs, 1))!.description)

        let toAddress = BitcoinAddress(string: "2NFU79Kzp4NV6YzZgei7MpMYJC2CamRgXHn")!
        let changeAddress = BitcoinAddress(string: "2Muj4yF9hSDyf93AQNeY8oAbe59mGpyTPM9")!

        let address = changeAddress
        let addressScript = BitcoinScript.buildScript(for: address)!
        let unspentOutput = BitcoinTransactionOutput(value: 800000, script: addressScript)

        let unspentOutpoint = BitcoinOutPoint(hash: Data(hexString: "de8804c613f8da43fef67bbd2538ac9bad2c1d3ab944265dce99e37fe25d5ee0")!, index: 1)

        let utxo = BitcoinUnspentTransaction(output: unspentOutput, outpoint: unspentOutpoint)

        let utxoKey = PrivateKey(wif: "Kwi8EArppSCAiMRNNHE9u8HF5p26MzW7U3uoUipyq9xisEAazPaF")!

        let provider = BitcoinDefaultPrivateKeyProvider(keys: [utxoKey])
        provider.scriptsByScriptHash = [
            scripthash: redeemScript,
        ]

        let unsignedTx = BitcoinTransaction.build(to: toAddress, amount: 600, fee: 5, changeAddress: changeAddress, utxos: [utxo])
        let signer = BitcoinTransactionSigner(keyProvider: provider, transaction: unsignedTx, hashType: .all)
        let signedTx = try signer.sign([utxo])

        var serialized = Data()
        signedTx.encode(into: &serialized)

        XCTAssertEqual(serialized.hexString, "0100000001de8804c613f8da43fef67bbd2538ac9bad2c1d3ab944265dce99e37fe25d5ee001000000d300483045022100a7cfcee67e4f3b1ad1cea991d18e26a162b2d0603188ecbcb488b9d94994a3920220376d6fe42117a180005935163a87d835c829d0648cf11a4b49afb98e9014f32a014c87514104334fb58fbad88139aad2b6e34ce42bb65f3a85454c04388a8e770a170f14f9b3bfbf6f8e766718531f5db21f9a1c00006f5f447db384c5288546396cca1725e14104334fb58fbad88139aad2b6e34ce42bb65f3a85454c04388a8e770a170f14f9b3bfbf6f8e766718531f5db21f9a1c00006f5f447db384c5288546396cca1725e152aeffffffff02580200000000000017a914f3c2762c23343f13f59f898c1aa9b4245454d11f87a3320c000000000017a9141b345ee77f18502f9b6774cfe6eb08cf303a22528700000000")

    }

    func testSegWitTransaction() throws {
        let toAddress = BitcoinAddress(string: "2NFU79Kzp4NV6YzZgei7MpMYJC2CamRgXHn")!
        let changeAddress = BitcoinSegwitAddress(string: "tb1qyhkw8rzzpwap78625yjkqzcpl2djdafucjcga7")!

        let address = changeAddress
        let addressScript = BitcoinScript.buildScript(for: address)!
        let unspentOutput = BitcoinTransactionOutput(value: 160000, script: addressScript)

        let unspentOutpoint = BitcoinOutPoint(hash: Data(hexString: "45cbfdde67d9c0f35549adb6b2920600f88a1bb7ba081460f529cb2eaf2f305d")!, index: 0)

        let utxo = BitcoinUnspentTransaction(output: unspentOutput, outpoint: unspentOutpoint)

        let utxoKey = PrivateKey(wif: "Kwi8EArppSCAiMRNNHE9u8HF5p26MzW7U3uoUipyq9xisEAazPaF")!

        let provider = BitcoinDefaultPrivateKeyProvider(keys: [utxoKey])

        let unsignedTx = BitcoinTransaction.build(to: toAddress, amount: 600, fee: 1, changeAddress: changeAddress, utxos: [utxo])
        let signer = BitcoinTransactionSigner(keyProvider: provider, transaction: unsignedTx, hashType: .all)
        let signedTx = try signer.sign([utxo])

        var serialized = Data()
        signedTx.encode(into: &serialized)
        XCTAssertEqual(serialized.hexString, "0100000000010145cbfdde67d9c0f35549adb6b2920600f88a1bb7ba081460f529cb2eaf2f305d0000000000ffffffff02580200000000000017a914f3c2762c23343f13f59f898c1aa9b4245454d11f87a76e02000000000016001425ece38c420bba1f1f4aa125600b01fa9b26f53c0247304402200901a2f0d894bfe3e8017f0ff876fa207812ab594c243eea07dd017c3918a56802207703f02814a4bc4cd297bee521fe5c51b87c53181e6286f4f92ad7ceef981e9c012103334fb58fbad88139aad2b6e34ce42bb65f3a85454c04388a8e770a170f14f9b300000000")

    }

    // regular transaction
    func testRegularTransaction() throws {

        let toAddress = BitcoinAddress(string: "2NFU79Kzp4NV6YzZgei7MpMYJC2CamRgXHn")!
        let changeAddress = BitcoinAddress(string: "miyV5UgyEyG8kiueMvxX3NnLug7vbtoCtA")!

        let address = changeAddress
        let addressScript = BitcoinScript.buildScript(for: address)!
        let unspentOutput = BitcoinTransactionOutput(value: 160000, script: addressScript)

        let unspentOutpoint = BitcoinOutPoint(hash: Data(hexString: "7373ad41ef97b842c272e97601dcdc73b67e46405a7af5957bd2d52a069f2178")!, index: 0)

        let utxo = BitcoinUnspentTransaction(output: unspentOutput, outpoint: unspentOutpoint)

        let utxoKey = PrivateKey(wif: "Kwi8EArppSCAiMRNNHE9u8HF5p26MzW7U3uoUipyq9xisEAazPaF")!

        let provider = BitcoinDefaultPrivateKeyProvider(keys: [utxoKey])

        let unsignedTx = BitcoinTransaction.build(to: toAddress, amount: 600, fee: 1, changeAddress: changeAddress, utxos: [utxo])
        let signer = BitcoinTransactionSigner(keyProvider: provider, transaction: unsignedTx, hashType: .all)
        let signedTx = try signer.sign([utxo])

        var serialized = Data()
        signedTx.encode(into: &serialized)
        XCTAssertEqual(serialized.hexString, "01000000017373ad41ef97b842c272e97601dcdc73b67e46405a7af5957bd2d52a069f2178000000006a4730440220575f0b621f298a2f20fb5a7c42808cea5d31d8f39b44b8a90e0e0f286109dfa3022079b7d00319d6aa53582148b64b5df3b090aeedc511d4ce5ea7e9cc27d6467f1f012103334fb58fbad88139aad2b6e34ce42bb65f3a85454c04388a8e770a170f14f9b3ffffffff02580200000000000017a914f3c2762c23343f13f59f898c1aa9b4245454d11f87a76e0200000000001976a91425ece38c420bba1f1f4aa125600b01fa9b26f53c88ac00000000")
    }

    //P2WPSH-in-P2SH
    func testSignTransaction() throws {
        let toAddress = BitcoinAddress(string: "2NFU79Kzp4NV6YzZgei7MpMYJC2CamRgXHn")!
        let changeAddress = BitcoinAddress(string: "2N3fyutnN34Yekedzs5b724nkFrWdh1XbUM")!

        let address = changeAddress
        let addressScript = BitcoinScript.buildScript(for: address)!
        let unspentOutput = BitcoinTransactionOutput(value: 160000, script: addressScript)

        let unspentOutpoint = BitcoinOutPoint(hash: Data(hexString: "fedea64307e83f801ff4d002538fac494150c2002901644a837d272aaf3462f8")!, index: 1)

        let utxo = BitcoinUnspentTransaction(output: unspentOutput, outpoint: unspentOutpoint)

        let utxoKey = PrivateKey(wif: "Kwi8EArppSCAiMRNNHE9u8HF5p26MzW7U3uoUipyq9xisEAazPaF")!

        let redeemScript = BitcoinScript.buildPayToWitnessPubkeyHash(utxoKey.publicKey(compressed: true).bitcoinKeyHash)

        let scripthash = Crypto.sha256ripemd160(redeemScript.data)

        let provider = BitcoinDefaultPrivateKeyProvider(keys: [utxoKey])

        provider.scriptsByScriptHash = [
            scripthash: redeemScript,
        ]
        let unsignedTx = BitcoinTransaction.build(to: toAddress, amount: 600, fee: 1, changeAddress: changeAddress, utxos: [utxo])
        let signer = BitcoinTransactionSigner(keyProvider: provider, transaction: unsignedTx, hashType: .all)
        let signedTx = try signer.sign([utxo])

        var serialized = Data()
        signedTx.encode(into: &serialized)

        XCTAssertEqual(serialized.hexString, "01000000000101fedea64307e83f801ff4d002538fac494150c2002901644a837d272aaf3462f8010000001716001425ece38c420bba1f1f4aa125600b01fa9b26f53cffffffff02580200000000000017a914f3c2762c23343f13f59f898c1aa9b4245454d11f87a76e02000000000017a914725fe836a173ba865b54dd589b0a6b84fe111dc28702483045022100bcaf48bc52b74cf5e8f958355028922ba51434e6c870a5b4ed0dcac39de7cefc02202cb0d6568467345a6cdea3a3ab6ab2ad62eef8964f77160aefce2f4039c93ad6012103334fb58fbad88139aad2b6e34ce42bb65f3a85454c04388a8e770a170f14f9b300000000")

    }

}
