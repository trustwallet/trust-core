// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public final class Aion: Ethereum {

    /// SLIP-044 coin type.
    public override var coinType: SLIP.CoinType {
        return .aion
    }

    public override func address(for publicKey: PublicKey) -> Address {
        return publicKey.ethereumAddress
    }

    public override func address(string: String) -> Address? {
        return AionAddress(string: string)
    }

    public override func address(data: Data) -> Address? {
        return AionAddress(data: data)
    }
}
