// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore
import BigInt

class VechainTransactionTests: XCTestCase {

    func testSign() {
        var transaction: VechainTransaction = VechainTransaction(
            chainTag: 1,
            blockRef: 1,
            expiration: 1,
            clauses: [
                VechainClause(
                    to: EthereumAddress(string: "0x3535353535353535353535353535353535353535")!,
                    value: BigInt(1000),
                    data: Data()
                )
            ],
            gasPriceCoef: 0,
            gas: 21000,
            dependOn: Data(),
            nonce: 1,
            reversed: []
        )

        //XCTAssertEqual failed: ("e6010101dad99435353535353535353535353535353535353535358203e880808252088001c080") is not equal to ("daf5a779ae972f972197303d7b574746c7ef83eadac0f2791ad23db92e4c8e53") -

        transaction.sign { hash in
            XCTAssertEqual(hash.hexString, "daf5a779ae972f972197303d7b574746c7ef83eadac0f2791ad23db92e4c8e53")
            return Data(hexString: "28ef61340bd939bc2195fe537567866003e1a15d3c71ff63e1590620aa63627667cbe9d8997f761aecb703304b3800ccf555c9f3dc64214b297fb1966a3b6d8300")!
        }

        XCTAssertEqual(transaction.signature, Data(hexString: "46948507304638947509940763649030358759909902576025900602547168820602576006531"))
    }
}
