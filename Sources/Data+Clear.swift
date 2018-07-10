// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

extension Data {
    mutating func clear() {
        replaceSubrange(0 ..< count, with: repeatElement(0, count: count))
    }
}
