// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct WanchainAddress: Address, Hashable {

    public static let size = EthereumAddress.size

    static public func isValid(data: Data) -> Bool {
        return EthereumAddress.isValid(data: data)
    }

    static public func isValid(string: String) -> Bool {
        return EthereumAddress.isValid(string: string)
    }

    public let data: Data
    public let checksumString: String

    public init?(data: Data) {
        guard WanchainAddress.isValid(data: data) else {
            return nil
        }
        self.data = data
        checksumString = EthereumChecksum.computeString(for: data, type: .wanchain)
    }

    public init?(string: String) {
        guard let data = Data(hexString: string), WanchainAddress.isValid(data: data) else {
            return nil
        }
        self.init(data: data)
    }

    public var description: String {
        return checksumString
    }

    public var hashValue: Int {
        return data.hashValue
    }

    public static func == (lhs: WanchainAddress, rhs: WanchainAddress) -> Bool {
        return lhs.data == rhs.data
    }
}
