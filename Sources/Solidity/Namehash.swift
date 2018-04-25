// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

/// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-137.md
extension String {
    /// sha3 keccak 256
    public func sha3() -> Data {
        guard let data = self.data(using: .utf8) else {
            return Data()
        }
        return data.sha3()
    }

    public var labelhash: Data {
        return self.sha3()
    }

    public var namehash: Data {
        var node = [UInt8].init(repeating: 0x0, count: 32)
        if !self.isEmpty {
            node = self.split(separator: ".")
                .map { Array($0.utf8).sha3() }
                .reversed()
                .reduce(node) { return ($0 + $1).sha3() }
        }
        return Data(node)
    }
}

extension Array where Element == UInt8 {
    /// sha3 keccak 256
    public func sha3() -> [Element] {
        let data = Data(bytes: self)
        let hashed = EthereumCrypto.hash(data)
        return Array(hashed)
    }
}

extension Data {
    /// sha3 keccak 256
    public func sha3() -> Data {
        return EthereumCrypto.hash(self)
    }
}
