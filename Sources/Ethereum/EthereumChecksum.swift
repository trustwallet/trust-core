// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public enum EthereumChecksumType {
    case EIP55
    case Wanchain
}

public struct EthereumChecksum {
    public static func computeString(for data: Data, type: EthereumChecksumType) -> String {
        let addressString = data.hexString
        let hashInput = addressString.data(using: .ascii)!
        let hash = Crypto.hash(hashInput).hexString

        var string = "0x"
        for (a, h) in zip(addressString, hash) {
            switch (a, h) {
            case ("0", _), ("1", _), ("2", _), ("3", _), ("4", _), ("5", _), ("6", _), ("7", _), ("8", _), ("9", _):
                string.append(a)
            case (_, "8"), (_, "9"), (_, "a"), (_, "b"), (_, "c"), (_, "d"), (_, "e"), (_, "f"):
                switch type {
                case .EIP55:
                    string.append(contentsOf: String(a).uppercased())
                case .Wanchain:
                    string.append(contentsOf: String(a).lowercased())
                }
            default:
                switch type {
                case .EIP55:
                    string.append(contentsOf: String(a).lowercased())
                case .Wanchain:
                    string.append(contentsOf: String(a).uppercased())
                }
            }
        }

        return string
    }
}
