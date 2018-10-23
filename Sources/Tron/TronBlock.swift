// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit

public struct TronBlock {

    private let timestamp: Int64
    private let txTrieRoot: Data
    private let parentHash: Data
    private let number: Int64
    private let witnessAddress: Data
    private let version: Int32

    public init(
        timestamp: Int64,
        txTrieRoot: Data,
        parentHash: Data,
        number: Int64,
        witnessAddress: Data,
        version: Int32
    ) {
        self.timestamp = timestamp
        self.txTrieRoot = txTrieRoot
        self.parentHash = parentHash
        self.number = number
        self.witnessAddress = witnessAddress
        self.version = version
    }

    public var blockHeader: Protocol_BlockHeader {
        var blockHeader = Protocol_BlockHeader()
        var blockRaw = Protocol_BlockHeader.raw()
        blockRaw.timestamp = timestamp
        blockRaw.txTrieRoot = txTrieRoot
        blockRaw.parentHash = parentHash
        blockRaw.number = number
        blockRaw.witnessAddress = witnessAddress
        blockRaw.version = version
        blockHeader.rawData = blockRaw
        return blockHeader
    }
}
