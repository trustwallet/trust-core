// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import Security

public final class EthereumPrivateKey: PrivateKey {
    /// Validates that raw data is a valid private key.
    static public func isValid(data: Data) -> Bool {
        // Check length
        if data.count != Ethereum.privateKeySize {
            return false
        }

        // Check for zero address
        if !data.contains(where: { $0 != 0 }) {
            return false
        }

        return true
    }

    /// Validates that the string is a valid private key.
    static public func isValid(string: String) -> Bool {
        guard let data = Data(hexString: string) else {
            return false
        }
        return data.count == Ethereum.privateKeySize
    }

    /// Raw representation of the private key.
    public let data: Data

    /// Public key.
    public var publicKey: PublicKey {
        return EthereumPublicKey(data: EthereumCrypto.getPublicKey(from: data))!
    }

    /// Creates a new private key.
    public init() {
        let privateAttributes: [String: Any] = [
            kSecAttrIsExtractable as String: true,
        ]
        let parameters: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeEC,
            kSecAttrKeySizeInBits as String: 256,
            kSecPrivateKeyAttrs as String: privateAttributes,
        ]

        var pubKey: SecKey?
        var privKey: SecKey?
        let status = SecKeyGeneratePair(parameters as CFDictionary, &pubKey, &privKey)
        guard let privateKey = privKey, status == noErr else {
            fatalError("Failed to generate key pair")
        }

        guard let keyRepresentation = SecKeyCopyExternalRepresentation(privateKey, nil) as Data? else {
            fatalError("Failed to extract new private key")
        }
        data = keyRepresentation.suffix(32)
    }

    /// Creates a private key from a string representation.
    public init?(string: String) {
        guard let data = Data(hexString: string) else {
            return nil
        }
        self.data = data
    }

    /// Creates a private key from a raw representation.
    public init?(data: Data) {
        self.data = data
    }

    public var description: String {
        return data.hexString
    }
}
