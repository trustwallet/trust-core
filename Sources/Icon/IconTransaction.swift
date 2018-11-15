// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import BigInt

public struct IconTransaction {
    public let from: IconAddress
    public let to: IconAddress
    public let value: BigInt
    public let stepLimit: BigInt
    public let timestamp: Date
    public let nonce: BigInt
    public let nid: BigInt
    public let version: BigInt

    var microsecondTimestamp: BigInt {
        return BigInt(floor(timestamp.timeIntervalSince1970)*1000*1000)
    }

    public init(
        from: IconAddress,
        to: IconAddress,
        value: BigInt,
        stepLimit: BigInt,
        timestamp: Date,
        nonce: BigInt,
        nid: BigInt,
        version: BigInt
        ) {
        self.from = from
        self.to = to
        self.value = value
        self.stepLimit = stepLimit
        self.timestamp = timestamp
        self.nonce = nonce
        self.nid = nid
        self.version = version
    }
}
