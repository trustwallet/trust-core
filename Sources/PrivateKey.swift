// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public final class PrivateKey: Hashable, CustomStringConvertible {
    /// Private key size in bytes.
    public static let size = 32

    /// Validates that raw data is a valid private key.
    static public func isValid(data: Data) -> Bool {
        // Check length
        if data.count != PrivateKey.size {
            return false
        }

        // Check for zero address
        guard data.contains(where: { $0 != 0 }) else {
            return false
        }

        return true
    }

    /// Raw representation of the private key.
    public private(set) var data: Data

    /// Creates a new private key.
    public init() {
        let privateAttributes: [String: Any] = [
            kSecAttrIsExtractable as String: true,
        ]
        let parameters: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeEC,
            kSecAttrKeySizeInBits as String: PrivateKey.size * 8,
            kSecPrivateKeyAttrs as String: privateAttributes,
        ]

        guard let privateKey = SecKeyCreateRandomKey(parameters as CFDictionary, nil) else {
            fatalError("Failed to generate key pair")
        }
        guard var keyRepresentation = SecKeyCopyExternalRepresentation(privateKey, nil) as Data? else {
            fatalError("Failed to extract new private key")
        }
        defer {
            keyRepresentation.clear()
        }
        data = Data(keyRepresentation.suffix(PrivateKey.size))
    }

    /// Creates a private key from a raw representation.
    public init?(data: Data) {
        if !PrivateKey.isValid(data: data) {
            return nil
        }
        self.data = Data(data)
    }

    deinit {
        // Clear memory
        data.clear()
    }

    /// Returns the public key associated with this pirvate key.
    ///
    /// - Parameter compressed: whether to generate a compressed public key
    /// - Returns: the public key
    public func publicKey(compressed: Bool = false) -> PublicKey {
        let pkData: Data
        if compressed {
            pkData = Crypto.getCompressedPublicKey(from: data)
        } else {
            pkData = Crypto.getPublicKey(from: data)
        }

        return PublicKey(data: pkData)!
    }

    /// Signs a hash.
    public func sign(hash: Data) -> Data {
        return Crypto.sign(hash: hash, privateKey: data)
    }

    /// Signs a hash, encodes the result using DER.
    public func signAsDER(hash: Data) -> Data {
        return Crypto.signAsDER(hash: hash, privateKey: data)
    }

    public var description: String {
        return data.hexString
    }

    // MARK: Hashable

    public var hashValue: Int {
        return data.hashValue
    }

    public static func == (lhs: PrivateKey, rhs: PrivateKey) -> Bool {
        return lhs.data == rhs.data
    }
}
