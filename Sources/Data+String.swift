// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

extension Data {
    public func toString() -> String {
        return String(data: self, encoding: .utf8) ?? ""
    }
}

extension String {
    public func toData() -> Data {
        return Data(utf8)
    }

    public func toBase64Decoded() -> Data? {
        return Data(base64Encoded: self)
    }
}
