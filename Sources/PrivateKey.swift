// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public protocol PrivateKey: CustomStringConvertible {
    /// Validates that raw data is a valid private key.
    static func isValid(data: Data) -> Bool

    /// Validates that the string is a valid private key.
    static func isValid(string: String) -> Bool

    /// Raw representation of the private key.
    var data: Data { get }

    /// Public key.
    var publicKey: PublicKey { get }

    /// Creates a new private key.
    init()

    /// Creates a private key from a string representation.
    init?(string: String)

    /// Creates a private key from a raw representation.
    init?(data: Data)
}
