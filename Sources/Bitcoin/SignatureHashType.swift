// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

/// Signature hash types/flags
public struct SignatureHashType: OptionSet {
    public var rawValue: Int32

    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }

    public var single: Bool {
        return (rawValue & 0x1f) == SignatureHashType.single.rawValue
    }

    public var none: Bool {
        return (rawValue & 0x1f) == SignatureHashType.none.rawValue
    }

    public static let all = SignatureHashType(rawValue: 1)
    public static let none = SignatureHashType(rawValue: 2)
    public static let single = SignatureHashType(rawValue: 3)
    public static let fork = SignatureHashType(rawValue: 0x40)
    public static let anyoneCanPay = SignatureHashType(rawValue: 0x80)
}
