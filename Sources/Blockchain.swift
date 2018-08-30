// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

/// Blockchain types
public enum BlockchainType {
    case bitcoin
    case ethereum
    case wanchain
    case vechain
    case tron
}

/// Blockchains
public struct Blockchain: Equatable {
    public var chainID: Int
    public var type: BlockchainType

    public init(chainID: Int, type: BlockchainType) {
        self.chainID = chainID
        self.type = type
    }
}

extension Blockchain {
    public static let bitcoin = Blockchain(chainID: 0, type: .bitcoin)
    public static let ethereum = Blockchain(chainID: 1, type: .ethereum)
    public static let go = Blockchain(chainID: 60, type: .ethereum)
    public static let poa = Blockchain(chainID: 99, type: .ethereum)
    public static let callisto = Blockchain(chainID: 820, type: .ethereum)
    public static let ethereumClassic = Blockchain(chainID: 61, type: .ethereum)
    public static let ethereumClassicTestnet = Blockchain(chainID: 62, type: .ethereum)
    public static let wanchain = Blockchain(chainID: 1, type: .wanchain)
    public static let vechain = Blockchain(chainID: 74, type: .vechain)
    public static let tron = Blockchain(chainID: 1, type: .tron)
}
