// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public class BitcoinCash: Bitcoin {

    public override init(purpose: Purpose = .bip44) {
        super.init(purpose: purpose)
    }

    override public var coinType: SLIP.CoinType {
        return .bitcoincash
    }

    override public var supportSegwit: Bool {
        return false
    }

    override public func address(for publicKey: PublicKey) -> Address {
        return publicKey.compressed.cashAddress()
    }

    override open func address(string: String) -> Address? {
        if let cashAddr = BitcoinCashAddress(string: string) {
            return cashAddr
        } else {
            return BitcoinAddress(string: string)
        }
    }

    override open func address(data: Data) -> Address? {
        if let cashAddr = BitcoinCashAddress(data: data) {
            return cashAddr
        } else {
            return BitcoinAddress(data: data)
        }
    }
}
