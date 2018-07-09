// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import Security

public final class BitcoinPrivateKey: PrivateKey {
    /// Validates that raw data is a valid private key.
    static public func isValid(data: Data) -> Bool {
        // Check length
        if data.count != Bitcoin.privateKeySize {
            return false
        }

        // Check for zero address
        if !data.contains(where: { $0 != 0 }) {
            return false
        }

        let max: [UInt8] = [
            0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
            0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE,
            0xBA, 0xAE, 0xDC, 0xE6, 0xAF, 0x48, 0xA0, 0x3B,
            0xBF, 0xD2, 0x5E, 0x8C, 0xD0, 0x36, 0x41, 0x40,
            ]
        for (index, byte) in zip(data.indices, data) {
            if byte < max[index] {
                return true
            }
            if byte > max[index] {
                return false
            }
        }

        return true
    }

    /// Validates that the string is a valid private key.
    static public func isValid(string: String) -> Bool {
        guard let decoded = BitcoinCrypto.base58Decode(string, expectedSize: Bitcoin.privateKeySize + 1) else {
            return false
        }

        // Verify size
        if decoded.count != 1 + Bitcoin.privateKeySize {
            return false
        }

        // Verify network ID
        let networkID = decoded[0]
        if networkID != Bitcoin.MainNet.privateKey && networkID != Bitcoin.TestNet.privateKey {
            return false
        }

        return true
    }

    /// Raw representation of the private key.
    public let data: Data

    /// Public key.
    public var publicKey: PublicKey {
        return BitcoinPublicKey(data: BitcoinCrypto.getPublicKey(from: data))!
    }

    /// Creates a new private key.
    public init() {
        data = Data(count: Bitcoin.privateKeySize)
        repeat {
            let result = data.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, Bitcoin.privateKeySize, $0) }
            if result != errSecSuccess {
                fatalError("Failed to generate random bytes for the private key")
            }
        } while !BitcoinPrivateKey.isValid(data: data)
    }

    /// Creates a private key from a string representation.
    public init?(string: String) {
        guard let decoded = BitcoinCrypto.base58Decode(string, expectedSize: Bitcoin.privateKeySize + 1) else {
            return nil
        }

        // Verify size
        if decoded.count != 1 + Bitcoin.privateKeySize {
            return nil
        }

        // Verify network ID
        let networkID = decoded[0]
        if networkID != Bitcoin.MainNet.privateKey && networkID != Bitcoin.TestNet.privateKey {
            return nil
        }

        data = Data(decoded.dropFirst())
    }

    /// Creates a private key from a raw representation.
    public init?(data: Data) {
        if !BitcoinPrivateKey.isValid(data: data) {
            return nil
        }
        self.data = data
    }

    public var description: String {
        let payload = Data([Bitcoin.MainNet.privateKey]) + data
        return BitcoinCrypto.base58Encode(payload)
    }
}
