// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

struct IconSigner {
    func hash(transaction: IconTransaction) -> Data {
        /// from: Wallet address of the sender - Format: ‘hx’ + 40 digit hex string
        /// to: Wallet address of the recipient - Format: ‘hx’ + 40 digit hex string
        /// value: Transfer amount (ICX) - Unit: 1/10^18 icx - Format: 0x + Hex string
        /// stepLimit: stepLimit is the amount of step to send with the transaction - Format: 0x + Hex string
        /// timestamp: UNIX epoch time (Begin from 1970.1.1 00:00:00) - Unit: microseconds
        /// nonce: Integer value increased by request to avoid ‘replay attack’
        /// nid: Network ID - Format: 0x + Hex string
        let tx = "icx_sendTransaction" +
            ".stepLimit." + "0x" + String(transaction.stepLimit, radix: 16, uppercase: false) +
            ".from." + transaction.from.description +
            ".nonce." + String(transaction.nonce) +
            ".timestamp." + transaction.timestamp +
            ".to." + transaction.to.description +
            ".value." + "0x" + String(transaction.value, radix: 16, uppercase: false) +
            ".nid." + "0x" + String(transaction.nid, radix: 16, uppercase: false)

        return Crypto.sha3_256(tx.data(using: .utf8)!)
    }
}
