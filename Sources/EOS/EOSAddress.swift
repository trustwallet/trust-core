// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public class EOSAddress: Address {

    public let data: Data

    public static func isValid(data: Data) -> Bool {
        return true
    }

    public static func isValid(string: String) -> Bool {
        return true
    }

    public required init?(data: Data) {
        if !EOSAddress.isValid(data: data) {
            return nil
        }
        self.data = data
    }

    public required convenience init?(string: String) {
        guard let decoded = Crypto.base58Decode(string) else {
            return nil
        }
        self.init(data: decoded)
    }

    public var description: String {
        return "EOS" + Crypto.base58Encode(data)
    }
}
