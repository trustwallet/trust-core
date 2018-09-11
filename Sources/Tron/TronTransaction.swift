// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

extension TronTransaction {
    public func hash() -> Data {
        return Crypto.sha256(self.rawData.data)
    }

    public func sign(key: String) -> TronTransaction {
        return self
    }
}
