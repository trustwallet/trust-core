// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import BigInt
import TrustCore
import XCTest

class TransactionSigningTests: XCTestCase {
    func testEIP155SignHash() {
        let address = EthereumAddress(string: "0x3535353535353535353535353535353535353535")!
        var transaction = Transaction(gasPrice: 20000000000, gasLimit: 21000, to: address)
        transaction.nonce = 9
        transaction.amount = BigInt("1000000000000000000")

        transaction.sign { hash in
            XCTAssertEqual(hash.hexString, "daf5a779ae972f972197303d7b574746c7ef83eadac0f2791ad23db92e4c8e53")
            return Data(repeating: 0, count: 65)
        }
    }

    func testHomesteadSignHash() {
        let address = EthereumAddress(string: "0x3535353535353535353535353535353535353535")!
        var transaction = Transaction(gasPrice: 20000000000, gasLimit: 21000, to: address)
        transaction.nonce = 9
        transaction.amount = BigInt("1000000000000000000")

        transaction.sign(chainID: 0) { hash in
            XCTAssertEqual(hash.hexString, "f9e36c28c8cb35adba138005c02ab7aa7fbcd891f3139cb2eeed052a51cd2713")
            return Data(repeating: 0, count: 65)
        }
    }

    func testSignTransaction() {
        var transaction = Transaction(gasPrice: 20000000000, gasLimit: 21000, to: EthereumAddress(string: "0x3535353535353535353535353535353535353535")!)
        transaction.nonce = 9
        transaction.amount = BigInt("1000000000000000000")

        transaction.sign { hash in
            XCTAssertEqual(hash.hexString, "daf5a779ae972f972197303d7b574746c7ef83eadac0f2791ad23db92e4c8e53")
            return Data(hexString: "28ef61340bd939bc2195fe537567866003e1a15d3c71ff63e1590620aa63627667cbe9d8997f761aecb703304b3800ccf555c9f3dc64214b297fb1966a3b6d8300")!
        }

        XCTAssertEqual(transaction.v, BigInt(37))
        XCTAssertEqual(transaction.r, BigInt("18515461264373351373200002665853028612451056578545711640558177340181847433846"))
        XCTAssertEqual(transaction.s, BigInt("46948507304638947509940763649030358759909902576025900602547168820602576006531"))
    }
}
