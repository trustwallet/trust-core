// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

/// Serialized Bitcoin script.
public final class BitcoinScript: BinaryEncoding, CustomDebugStringConvertible {
    public var bytes: [UInt8]

    public var data: Data {
        get {
            return Data(bytes: bytes)
        }
        set {
            bytes = Array(newValue)
        }
    }

    public init(bytes: [UInt8] = []) {
        self.bytes = bytes
    }

    public init(data: Data) {
        self.bytes = Array(data)
    }

    public var debugDescription: String {
        return data.hexString
    }

    /// Determines whether this is a pay-to-script-hash (P2SH) script.
    public var isPayToScriptHash: Bool {
        // Extra-fast test for pay-to-script-hash
        return bytes.count == 23 &&
            bytes[0] == OpCode.OP_HASH160 &&
            bytes[1] == 0x14 &&
            bytes[22] == OpCode.OP_EQUAL
    }

    /// Determines whether this is a pay-to-witness-script-hash (P2WSH) script.
    public var isPayToWitnessScriptHash: Bool {
        // Extra-fast test for pay-to-witness-script-hash
        return bytes.count == 22 &&
            bytes[0] == OpCode.OP_0 &&
            bytes[1] == 0x14
    }

    /// Determines whether this is a witness programm script.
    public var isWitnessProgram: Bool {
        if bytes.count < 4 || bytes.count > 42 {
            return false
        }
        if bytes[0] != OpCode.OP_0 && (bytes[0] < OpCode.OP_1 || bytes[0] > OpCode.OP_16) {
            return false
        }
        return bytes[1] + 2 == bytes.count
    }

    /// Decodes a small integer
    static func decodeNumber(opcode: UInt8) -> Int {
        if opcode == OpCode.OP_0 {
            return 0
        }
        assert(opcode >= OpCode.OP_1 && opcode <= OpCode.OP_16)
        return Int(opcode) - Int(OpCode.OP_1 - 1)
    }

    /// Matches the script to a pay-to-public-key (P2PK) script.
    ///
    /// - Returns: the public key.
    public func matchPayToPubkey() -> PublicKey? {
        if bytes.count == PublicKey.uncompressedSize + 2 && bytes[0] == PublicKey.uncompressedSize && bytes.last == OpCode.OP_CHECKSIG {
            let pubkeyData = Data(bytes: bytes[bytes.startIndex + 1 ..< bytes.startIndex + PublicKey.uncompressedSize + 1])
            return PublicKey(data: pubkeyData)
        }
        if bytes.count == PublicKey.compressedSize + 2 && bytes[0] == PublicKey.compressedSize && bytes.last == OpCode.OP_CHECKSIG {
            let pubkeyData = Data(bytes: bytes[bytes.startIndex + 1 ..< bytes.startIndex + PublicKey.compressedSize + 1])
            return PublicKey(data: pubkeyData)
        }
        return nil
    }

    /// Matches the script to a pay-to-public-key-hash (P2PKH).
    ///
    /// - Returns: the key hash.
    public func matchPayToPubkeyHash() -> Data? {
        if bytes.count == 25 && bytes[0] == OpCode.OP_DUP && bytes[1] == OpCode.OP_HASH160 && bytes[2] == 20 && bytes[23] == OpCode.OP_EQUALVERIFY && bytes[24] == OpCode.OP_CHECKSIG {
            return Data(bytes: bytes[bytes.startIndex + 3 ..< bytes.startIndex + 23])
        }
        return nil
    }

    /// Matches the script to a pay-to-script-hash (P2SH).
    ///
    /// - Returns: the script hash.
    public func matchPayToScriptHash() -> Data? {
        guard isPayToScriptHash else {
            return nil
        }
        return Data(bytes: bytes[2 ..< 22])
    }

    /// Matches the script to a pay-to-witness-public-key-hash (P2WPKH).
    ///
    /// - Returns: the key hash.
    public func matchPayToWitnessPublicKeyHash() -> Data? {
        if bytes.count == 22 && bytes[0] == OpCode.OP_0 && bytes[1] == 0x14 {
            return Data(bytes: bytes[2...])
        }
        return nil
    }

    /// Matches the script to a pay-to-witness-script-hash (P2WSH).
    ///
    /// - Returns: the script hash, a SHA256 of the witness script.
    public func matchPayToWitnessScriptHash() -> Data? {
        if bytes.count == 34 && bytes[0] == OpCode.OP_0 && bytes[1] == 0x20 {
            return Data(bytes: bytes[2...])
        }
        return nil
    }

    /// Matches the script to a multisig script.
    ///
    /// - Returns: the array of public keys and the number of required signatures.
    public func matchMultisig() -> ([PublicKey], required: Int)? {
        if bytes.count < 1 || bytes.last != OpCode.OP_CHECKMULTISIG {
            return nil
        }

        var keys = [PublicKey]()

        var it = bytes.startIndex
        guard let (opcode_M, _) = getScriptOp(index: &it), OpCode.isSmallInteger(opcode_M) else {
            return nil
        }
        let required = BitcoinScript.decodeNumber(opcode: opcode_M)
        while case .some(_, let data?) = getScriptOp(index: &it), let key = PublicKey(data: data) {
            keys.append(key)
        }
        it -= 1
        guard let (opcode_N, _) = getScriptOp(index: &it), OpCode.isSmallInteger(opcode_N) else {
            return nil
        }

        let expectedCount = BitcoinScript.decodeNumber(opcode: opcode_N)
        if keys.count != expectedCount || expectedCount < required {
            return nil
        }
        if it + 1 != bytes.endIndex {
            return nil
        }

        return (keys, required)
    }

    // MARK: Binary Coding

    public func encode(into data: inout Data) {
        writeCompactSize(bytes.count, into: &data)
        self.data.encode(into: &data)
    }
}
