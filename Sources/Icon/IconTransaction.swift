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
    public let nonce: BigInt?
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
        nonce: BigInt?,
        nid: BigInt,
        version: BigInt = BigInt(3)
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

    public var paramsHex: [String: String] {
        var params: [String: String] = [:]
        params["from"] = from.description
        params["to"] = to.description
        let microsecondTimestamp = UInt64(timestamp.timeIntervalSince1970 * 1000 * 1000)
        params["timestamp"] = "0x" + String(format: "%llx", microsecondTimestamp)
        if let nonce = nonce {
            params["nonce"] = "0x" + String(nonce, radix: 16, uppercase: false)
        }
        params["stepLimit"] = "0x" + String(stepLimit, radix: 16, uppercase: false)
        params["value"] = "0x" + String(value, radix: 16, uppercase: false)
        params["nid"] = "0x" + String(nid, radix: 16, uppercase: false)
        params["version"] = "0x" + String(version, radix: 16, uppercase: false)

        return params
    }
}
