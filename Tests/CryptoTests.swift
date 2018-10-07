// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class CryptoTests: XCTestCase {
    func testSign() {
        let hash = Data(hexString: "3F891FDA3704F0368DAB65FA81EBE616F4AA2A0854995DA4DC0B59D2CADBD64F")!
        let privateKey = Data(hexString: "D30519BCAE8D180DBFCC94FE0B8383DC310185B0BE97B4365083EBCECCD75759")!
        let signature = Crypto.sign(hash: hash, privateKey: privateKey)
        let publicKey = Crypto.getPublicKey(from: privateKey)

        XCTAssertEqual(signature.count, 65)
        XCTAssertEqual(signature.hexString, "e56cfc6bddb0f803ee41c163816c3aa924ea0aae937294daf6a55f948aab8b463746cd528a3ad0102b431d7c7cecec7d92b910fe57c1213514c12206c41f1fef00")
        XCTAssertTrue(Crypto.verify(signature: signature, message: hash, publicKey: publicKey))
    }

    func testRecoverPubkey() {
        let msg = "hello!".data(using: .utf8)!
        let hash = Crypto.hash(msg)
        let privateKey = Data(hexString: "D30519BCAE8D180DBFCC94FE0B8383DC310185B0BE97B4365083EBCECCD75759")!
        let signature = Crypto.sign(hash: hash, privateKey: privateKey)

        let data = Crypto.recoverPubkey(from: signature, message: hash)!
        let pubkey = PublicKey(data: data)
        XCTAssertEqual(pubkey?.ethereumAddress.description.lowercased(), "0x3994c38d3738e9d1be0e31483b8f56ba5546a640")
    }

    func testPersonalMessageRecoverPubkey() {
        let sig = Data(hexString: "2237bed7053f13935abf3c89841bc6baf28d880be6512a555a3745fec811497153871388e6a57f333c3bad0bd966861dbfb0d10d2fa068b1c6e5e54d7e5516671c")!

        let msg = "hello!".data(using: .utf8)!
        let prefix = "\u{19}Ethereum Signed Message:\n\(msg.count)".data(using: .utf8)!

        let hash = Crypto.hash(prefix + msg)
        let recovered = Crypto.recoverPubkey(from: sig, message: hash)!
        let ethPubRecover = PublicKey(data: recovered)!

        XCTAssertEqual(ethPubRecover.ethereumAddress.description.lowercased(), "0x94f227a17b669c4e469a5523e87601fce0addd61")
    }

    func testSignDER() {
        let hash = Data(hexString: "52204d20fd0131ae1afd173fd80a3a746d2dcc0cddced8c9dc3d61cc7ab6e966")!
        let privateKey = Data(hexString: "16f243e962c59e71e54189e67e66cf2440a1334514c09c00ddcc21632bac9808")!
        let signature = Crypto.signAsDER(hash: hash, privateKey: privateKey)

        XCTAssertEqual(signature.hexString, "3044022055f4b20035cbb2e85b7a04a0874c80d5822758f4e47a9a69db04b29f8b218f920220491e6a13296cfe2186da3a3ca565a179def3808b12d184553a8e3acfe1467273")
    }

    func testGetPublicKey() {
        let privateKey = Data(hexString: "7a28b5ba57c53603b0b07b56bba752f7784bf506fa95edc395f5cf6c7514fe9d")!
        XCTAssertEqual(Crypto.getPublicKey(from: privateKey).hexString, "0432d87c5cd4b31d81c5b010af42a2e413af253dc3a91bd3d53c6b2c45291c3de71633bf7793447a0d3ddde601f8d21668fca5b33324f14ebe7516eab0da8bab8f")
    }

    func testGetCompressedPublicKey() {
        let privateKey = Data(hexString: "7a28b5ba57c53603b0b07b56bba752f7784bf506fa95edc395f5cf6c7514fe9d")!
        XCTAssertEqual(Crypto.getCompressedPublicKey(from: privateKey).hexString, "0332d87c5cd4b31d81c5b010af42a2e413af253dc3a91bd3d53c6b2c45291c3de7")
    }

    func testGetED25519PublicKey() {
        let privateKey = Data(hexString: "0xca2327b0c60dc5573825fc16ac3accdb3009d1eda6b46f78212cfad0726483dbe77ba23bc030cbca2fa5c3cee25ea4ae851e947a1d4d0e54fe9ccced9f339b19")!
        XCTAssertEqual(Crypto.getED25519PublicKey(from: privateKey).hexString, "e77ba23bc030cbca2fa5c3cee25ea4ae851e947a1d4d0e54fe9ccced9f339b19")
    }

    func testDeriveSeed() {
        let mnemonic = "often tobacco bread scare imitate song kind common bar forest yard wisdom"
        let passphrase = "testtest123"
        let seed = Data(hexString: "b4186ab8ac0ebfd3c20f992d0b602639fe59f0e4d2e66dea487194580e0aa0031387c9f30488a7628ed7350a63dd97e1acb259896082e3b34a1ff0dd85c287d1")!

        XCTAssertEqual(Crypto.deriveSeed(mnemonic: mnemonic, passphrase: passphrase), seed)
    }

    func testEncode() {
        let message = "c61d43dc5bb7a4e754d111dae8105b6f25356492df5e50ecb33b858d94f8c338"
        let expected = "ship tube warfare resist kid inhale fashion captain sustain dog bitter tattoo fashion rather enter type extend grain solve arch sun ladder artefact bronze"
        let words = Crypto.generateMnemonic(seed: Data(hexString: message)!)
        XCTAssertEqual(words, expected)
    }

    func testValid() {
        let mnemonic = "ship tube warfare resist kid inhale fashion captain sustain dog bitter tattoo fashion rather enter type extend grain solve arch sun ladder artefact bronze"
        XCTAssertTrue(Crypto.isValid(mnemonic: mnemonic))
    }

    func testInvalid() {
        let mnemonic = "ship turd warfare resist kid inhale fashion captain sustain dog bitter tattoo fashion rather enter type extend grain solve arch sun ladder artefact bronze"
        XCTAssertFalse(Crypto.isValid(mnemonic: mnemonic))
    }

    func testSha3_256() {
        let fill1Data = Crypto.sha3_256(Data(hexString: "0x616263")!)
        XCTAssertEqual("3a985da74fe225b2045c172d6bd390bd855f086e3e9d525b46bfe24511431532", fill1Data.hexString)

        let fill2Data = Crypto.sha3_256(Data(hexString: "0x31")!)
        XCTAssertEqual("67b176705b46206614219f47a05aee7ae6a3edbe850bbbe214c536b989aea4d2", fill2Data.hexString)
    }
    
    func testBlake2b256() {
        let emptyData = Crypto.blake2b256(Data())

        XCTAssertEqual("0e5751c026e543b2e8ab2eb06099daa1d1e5df47778f7787faab45cdf12fe3a8", emptyData.hexString)

        let fill1Data = Crypto.blake2b256(Data(hexString: "0x616263")!)

        XCTAssertEqual("bddd813c634239723171ef3fee98579b94964e3bb1cb3e427262c8c068d52319", fill1Data.hexString)

        let fill2Data = Crypto.blake2b256(Data(hexString: "0x31")!)

        XCTAssertEqual("92cdf578c47085a5992256f0dcf97d0b19f1f1c9de4d5fe30c3ace6191b6e5db", fill2Data.hexString)
    }

    func testBech32Encoding() {
        var hrp: NSString?
        var data = Crypto.bech32Decode("tb1qw508d6qejxtdg4y5r3zarvary0c5xw7kxpjzsx", hrp: &hrp)!
        XCTAssertEqual(data.hexString, "000e140f070d1a001912060b0d081504140311021d030c1d03040f1814060e1e16")
        XCTAssertEqual(hrp!, "tb")

        data = Crypto.bech32Decode("bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4", hrp: &hrp)!
        XCTAssertEqual(data.hexString, "000e140f070d1a001912060b0d081504140311021d030c1d03040f1814060e1e16")
        XCTAssertEqual(hrp!, "bc")

        XCTAssertNotNil(Crypto.bech32Decode("bc1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3qccfmv3", hrp: nil))

        for invalid in [
            " 1nwldj5",
            "de1lg7wt\u{ff}",
            "an84characterslonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1569pvx",
        ] {
            var hrp: NSString?
            XCTAssertNil(Crypto.bech32Decode(invalid, hrp: &hrp))
            XCTAssertNil(hrp)
        }

        for valid in [
            "A12UEL5L",
            "split1checkupstagehandshakeupstreamerranterredcaperred2y9e3w",
            "11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqc8247j",
        ] {
            let index = valid.range(of: "1", options: .backwards)!.lowerBound
            let expected = String(valid[..<index]).lowercased()
            var hrp: NSString?
            let data = Crypto.bech32Decode(valid, hrp: &hrp)
            XCTAssertNotNil(data)
            XCTAssertEqual(expected, hrp! as String)

            let rebuilt = Crypto.bech32Encode(data!, hrp: expected)
            XCTAssertEqual(rebuilt, valid.lowercased())
        }
    }
}
