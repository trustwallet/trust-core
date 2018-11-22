// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public final class Wanchain: Ethereum {
    public override var chainID: Int {
        return 1
    }

    public override var coinType: SLIP.CoinType {
        return .wanchain
    }

    public override func address(for publicKey: PublicKey) -> Address {
        return publicKey.wanchainAddress
    }

    public override func address(string: String) -> Address? {
        return WanchainAddress(string: string)
    }

    public override func address(data: Data) -> Address? {
        return WanchainAddress(data: data)
    }
}

public extension PublicKey {
    public var wanchainAddress: WanchainAddress {
        let hash = Crypto.hash(data[1...])
        return WanchainAddress(data: hash.suffix(WanchainAddress.size))!
    }
}
