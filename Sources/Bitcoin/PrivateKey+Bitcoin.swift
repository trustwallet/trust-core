// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

extension PrivateKey {
    /// Creates a `PrivateKey` from a Bitcoin WIF (wallet import format) string.

    static let prefixSet = Set([
        Bitcoin().privateKeyPrefix,
        Litecoin().privateKeyPrefix,
        Dash().privateKeyPrefix,
        Bitcoin(network: .test).privateKeyPrefix,
        Litecoin(network: .test).privateKeyPrefix,
        Dash(network: .test).privateKeyPrefix,
    ])

    public convenience init?(wif: String) {
        guard let decoded = Crypto.base58Decode(wif) else {
            return nil
        }
        guard PrivateKey.prefixSet.contains(decoded[0]) else {
            return nil
        }
        if decoded.count == 34 && decoded.last != 0x01 {
            return nil
        }
        self.init(data: Data(decoded[1 ..< 33]))
    }

    public var wif: String {
        let result = Data(bytes: [0x80]) + data
        let check = Crypto.sha256sha256(result)[0..<4]
        return Crypto.base58EncodeRaw(result + check)
    }
}
