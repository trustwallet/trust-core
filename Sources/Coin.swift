// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

/// Coin types for Level 2 of BIP44.
///
/// - SeeAlso: https://github.com/satoshilabs/slips/blob/master/slip-0044.md
public struct Coin: RawRepresentable, Equatable {
    public var rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension Coin {
    public static let bitcoin = Coin(rawValue: 0)
    public static let testNet = Coin(rawValue: 1)
    public static let ethereum = Coin(rawValue: 60)
    public static let ethereumClassic = Coin(rawValue: 61)
    public static let poa = Coin(rawValue: 178)
    public static let callisto = Coin(rawValue: 820)
    public static let gochain = Coin(rawValue: 6060)
}
