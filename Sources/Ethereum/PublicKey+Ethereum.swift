// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public extension PublicKey {
    /// Ethereum address.
    public var ethereumAddress: EthereumAddress {
        let hash = Crypto.hash(data[1...])
        return EthereumAddress(data: hash.suffix(EthereumAddress.size))!
    }
}
