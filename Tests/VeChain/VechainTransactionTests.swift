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
                ),
            ],
            gasPriceCoef: 0,
            gas: 21000,
            dependOn: Data(),
            nonce: 1,
            reversed: []
        )

        transaction.sign { hash in
            XCTAssertEqual(hash.hexString, "a39d0ac66fa3633ed6ab4266e1543c680b5b68155c7986fb5bfa83e2a56e6c6e")
            return Data(hexString: "28ef61340bd939bc2195fe537567866003e1a15d3c71ff63e1590620aa63627667cbe9d8997f761aecb703304b3800ccf555c9f3dc64214b297fb1966a3b6d8300")!
        }

        XCTAssertEqual(transaction.signature, Data(hexString: "28ef61340bd939bc2195fe537567866003e1a15d3c71ff63e1590620aa63627667cbe9d8997f761aecb703304b3800ccf555c9f3dc64214b297fb1966a3b6d8300"))
    }
}
