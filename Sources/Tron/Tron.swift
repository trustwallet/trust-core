// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public final class Tron: Bitcoin {
    override public var coinType: SLIP.CoinType {
        return .tron
    }
    override public var payToScriptHashAddressPrefix: UInt8 {
        return 0x41
    }

    override public var coinPurpose: Purpose {
        return .bip44
    }

    override public func address(for publicKey: PublicKey) -> Address {
        let hash = Data([payToScriptHashAddressPrefix]) + Crypto.hash(publicKey.data.dropFirst()).suffix(20)
        return BitcoinAddress(data: hash)!
    }
}
