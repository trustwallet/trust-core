// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public final class Icon: Ethereum {
    /// Chain identifier.
    public override var chainID: Int {
        return 888888 //Temporary
    }

    /// SLIP-044 coin type.
    public override var coinType: SLIP.CoinType {
        return .icon
    }

    public override func address(for publicKey: PublicKey) -> Address {
        return publicKey.iconAddress
    }

    public override func address(string: String) -> Address? {
        return IconAddress(string: string)
    }

    public override func address(data: Data) -> Address? {
        return IconAddress(data: data)
    }
}
