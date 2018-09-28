// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit

extension Date {
    var currentTimeMilliseconds: Int64 {
        let now = timeIntervalSince1970
        return Int64(now * 1000)
    }
}

