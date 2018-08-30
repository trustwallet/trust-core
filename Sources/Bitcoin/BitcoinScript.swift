// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

enum OpCode {
    // push value
    static let OP_0 = 0x00 as UInt8
    static let OP_FALSE = OP_0
    static let OP_PUSHDATA1 = 0x4c as UInt8
    static let OP_PUSHDATA2 = 0x4d as UInt8
    static let OP_PUSHDATA4 = 0x4e as UInt8
    static let OP_1NEGATE = 0x4f as UInt8
    static let OP_RESERVED = 0x50 as UInt8
    static let OP_1 = 0x51 as UInt8
    static let OP_TRUE = OP_1
    static let OP_2 = 0x52 as UInt8
    static let OP_3 = 0x53 as UInt8
    static let OP_4 = 0x54 as UInt8
    static let OP_5 = 0x55 as UInt8
    static let OP_6 = 0x56 as UInt8
    static let OP_7 = 0x57 as UInt8
    static let OP_8 = 0x58 as UInt8
    static let OP_9 = 0x59 as UInt8
    static let OP_10 = 0x5a as UInt8
    static let OP_11 = 0x5b as UInt8
    static let OP_12 = 0x5c as UInt8
    static let OP_13 = 0x5d as UInt8
    static let OP_14 = 0x5e as UInt8
    static let OP_15 = 0x5f as UInt8
    static let OP_16 = 0x60 as UInt8

    // control
    static let OP_NOP = 0x61 as UInt8
    static let OP_VER = 0x62 as UInt8
    static let OP_IF = 0x63 as UInt8
    static let OP_NOTIF = 0x64 as UInt8
    static let OP_VERIF = 0x65 as UInt8
    static let OP_VERNOTIF = 0x66 as UInt8
    static let OP_ELSE = 0x67 as UInt8
    static let OP_ENDIF = 0x68 as UInt8
    static let OP_VERIFY = 0x69 as UInt8
    static let OP_RETURN = 0x6a as UInt8

    // stack ops
    static let OP_TOALTSTACK = 0x6b as UInt8
    static let OP_FROMALTSTACK = 0x6c as UInt8
    static let OP_2DROP = 0x6d as UInt8
    static let OP_2DUP = 0x6e as UInt8
    static let OP_3DUP = 0x6f as UInt8
    static let OP_2OVER = 0x70 as UInt8
    static let OP_2ROT = 0x71 as UInt8
    static let OP_2SWAP = 0x72 as UInt8
    static let OP_IFDUP = 0x73 as UInt8
    static let OP_DEPTH = 0x74 as UInt8
    static let OP_DROP = 0x75 as UInt8
    static let OP_DUP = 0x76 as UInt8
    static let OP_NIP = 0x77 as UInt8
    static let OP_OVER = 0x78 as UInt8
    static let OP_PICK = 0x79 as UInt8
    static let OP_ROLL = 0x7a as UInt8
    static let OP_ROT = 0x7b as UInt8
    static let OP_SWAP = 0x7c as UInt8
    static let OP_TUCK = 0x7d as UInt8

    // splice ops
    static let OP_CAT = 0x7e as UInt8
    static let OP_SUBSTR = 0x7f as UInt8
    static let OP_LEFT = 0x80 as UInt8
    static let OP_RIGHT = 0x81 as UInt8
    static let OP_SIZE = 0x82 as UInt8

    // bit logic
    static let OP_INVERT = 0x83 as UInt8
    static let OP_AND = 0x84 as UInt8
    static let OP_OR = 0x85 as UInt8
    static let OP_XOR = 0x86 as UInt8
    static let OP_EQUAL = 0x87 as UInt8
    static let OP_EQUALVERIFY = 0x88 as UInt8
    static let OP_RESERVED1 = 0x89 as UInt8
    static let OP_RESERVED2 = 0x8a as UInt8

    // numeric
    static let OP_1ADD = 0x8b as UInt8
    static let OP_1SUB = 0x8c as UInt8
    static let OP_2MUL = 0x8d as UInt8
    static let OP_2DIV = 0x8e as UInt8
    static let OP_NEGATE = 0x8f as UInt8
    static let OP_ABS = 0x90 as UInt8
    static let OP_NOT = 0x91 as UInt8
    static let OP_0NOTEQUAL = 0x92 as UInt8

    static let OP_ADD = 0x93 as UInt8
    static let OP_SUB = 0x94 as UInt8
    static let OP_MUL = 0x95 as UInt8
    static let OP_DIV = 0x96 as UInt8
    static let OP_MOD = 0x97 as UInt8
    static let OP_LSHIFT = 0x98 as UInt8
    static let OP_RSHIFT = 0x99 as UInt8

    static let OP_BOOLAND = 0x9a as UInt8
    static let OP_BOOLOR = 0x9b as UInt8
    static let OP_NUMEQUAL = 0x9c as UInt8
    static let OP_NUMEQUALVERIFY = 0x9d as UInt8
    static let OP_NUMNOTEQUAL = 0x9e as UInt8
    static let OP_LESSTHAN = 0x9f as UInt8
    static let OP_GREATERTHAN = 0xa0 as UInt8
    static let OP_LESSTHANOREQUAL = 0xa1 as UInt8
    static let OP_GREATERTHANOREQUAL = 0xa2 as UInt8
    static let OP_MIN = 0xa3 as UInt8
    static let OP_MAX = 0xa4 as UInt8

    static let OP_WITHIN = 0xa5 as UInt8

    // crypto
    static let OP_RIPEMD160 = 0xa6 as UInt8
    static let OP_SHA1 = 0xa7 as UInt8
    static let OP_SHA256 = 0xa8 as UInt8
    static let OP_HASH160 = 0xa9 as UInt8
    static let OP_HASH256 = 0xaa as UInt8
    static let OP_CODESEPARATOR = 0xab as UInt8
    static let OP_CHECKSIG = 0xac as UInt8
    static let OP_CHECKSIGVERIFY = 0xad as UInt8
    static let OP_CHECKMULTISIG = 0xae as UInt8
    static let OP_CHECKMULTISIGVERIFY = 0xaf as UInt8

    // expansion
    static let OP_NOP1 = 0xb0 as UInt8
    static let OP_CHECKLOCKTIMEVERIFY = 0xb1 as UInt8
    static let OP_NOP2 = OP_CHECKLOCKTIMEVERIFY as UInt8
    static let OP_CHECKSEQUENCEVERIFY = 0xb2 as UInt8
    static let OP_NOP3 = OP_CHECKSEQUENCEVERIFY as UInt8
    static let OP_NOP4 = 0xb3 as UInt8
    static let OP_NOP5 = 0xb4 as UInt8
    static let OP_NOP6 = 0xb5 as UInt8
    static let OP_NOP7 = 0xb6 as UInt8
    static let OP_NOP8 = 0xb7 as UInt8
    static let OP_NOP9 = 0xb8 as UInt8
    static let OP_NOP10 = 0xb9 as UInt8

    static let OP_INVALIDOPCODE = 0xff as UInt8

    // Test for "small positive integer" script opcodes - OP_1 through OP_16.
    static func isSmallInteger(_ opcode: UInt8) -> Bool {
        return opcode >= OP_1 && opcode <= OP_16
    }
}

/// Serialized Bitcoin script.
public final class BitcoinScript: BinaryEncoding {
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

    var isPayToScriptHash: Bool {
        // Extra-fast test for pay-to-script-hash
        return bytes.count == 23 &&
            bytes[0] == OpCode.OP_HASH160 &&
            bytes[1] == 0x14 &&
            bytes[22] == OpCode.OP_EQUAL
    }

    var isPayToWitnessScriptHash: Bool {
        // Extra-fast test for pay-to-witness-script-hash
        return bytes.count == 34 &&
            bytes[0] == OpCode.OP_0 &&
            bytes[1] == 0x20
    }

    // A witness program is any valid CScript that consists of a 1-byte push opcode
    // followed by a data push between 2 and 40 bytes.
    func isWitnessProgram(version: inout Int, program: inout Data) -> Bool {
        if bytes.count < 4 || bytes.count > 42 {
            return false
        }
        if bytes[0] != OpCode.OP_0 && (bytes[0] < OpCode.OP_1 || bytes[0] > OpCode.OP_16) {
            return false
        }
        if bytes[1] + 2 == bytes.count {
            version = BitcoinScript.decodeNumber(opcode: bytes[0])
            program = Data(bytes: bytes[2...])
            return true
        }
        return false
    }

    func isPushOnly(at index: inout Int) -> Bool {
        while index < bytes.endIndex {
            var opcode = 0 as UInt8
            var contents = Data()
            if !getScriptOp(index: &index, opcode: &opcode, contents: &contents) {
                return false
            }
            if opcode > OpCode.OP_16 {
                return false
            }
        }
        return true
    }

    /// Builds a standard 'pay to public key hash' script.
    public static func buildPayToPublicKeyHash(_ pubKeyHash: Data) -> BitcoinScript {
        var data = Data(capacity: 5 + pubKeyHash.count)
        data.append(contentsOf: [OpCode.OP_DUP, OpCode.OP_HASH160])
        data.append(UInt8(pubKeyHash.count))
        data.append(pubKeyHash)
        data.append(contentsOf: [OpCode.OP_EQUALVERIFY, OpCode.OP_CHECKSIG])
        return BitcoinScript(data: data)
    }

    /// Decodes a small integer
    static func decodeNumber(opcode: UInt8) -> Int {
        if opcode == OpCode.OP_0 {
            return 0
        }
        assert(opcode >= OpCode.OP_1 && opcode <= OpCode.OP_16)
        return Int(opcode) - Int(OpCode.OP_1 - 1)
    }

    /// Encodes a small integer
    static func encodeNumber(_ n: Int) -> UInt8 {
        assert(n >= 0 && n <= 16)
        if n == 0 {
            return OpCode.OP_0
        }
        return OpCode.OP_1 + UInt8(n - 1)
    }

    func getScriptOp(index: inout Int, opcode opcodeRet: inout UInt8, contents: inout Data) -> Bool {
        let end = bytes.endIndex
        opcodeRet = OpCode.OP_INVALIDOPCODE
        contents.removeAll()

        // Read instruction
        if index >= end {
            return false
        }
        let opcode = bytes[index]
        index += 1

        // Immediate operand
        if opcode <= OpCode.OP_PUSHDATA4 {
            var size = 0
            if opcode < OpCode.OP_PUSHDATA1 {
                size = Int(opcode)
            } else if opcode == OpCode.OP_PUSHDATA1 {
                if end - index < 1 {
                    return false
                }
                size = index
                index += 1
            } else if opcode == OpCode.OP_PUSHDATA2 {
                if end - index < 2 {
                    return false
                }
                size = Int(readLE16(at: index))
                index += 2
            } else if opcode == OpCode.OP_PUSHDATA4 {
                if end - index < 4 {
                    return false
                }
                size = Int(readLE32(at: index))
                index += 4
            }
            if end - index < size {
                return false
            }
            contents.append(data[index ..< index + size])
            index += size
        }

        opcodeRet = opcode
        return true
    }

    /// Reads a little-endian `UInt16` from the script.
    private func readLE16(at index: Int) -> UInt16 {
        return bytes.withUnsafeBufferPointer { ptr in
            (ptr.baseAddress! + index).withMemoryRebound(to: UInt16.self, capacity: 1) { intptr in
                UInt16(littleEndian: intptr.pointee)
            }
        }
    }

    /// Reads a little-endian `UInt32` from the script.
    private func readLE32(at index: Int) -> UInt32 {
        return bytes.withUnsafeBufferPointer { ptr in
            (ptr.baseAddress! + index).withMemoryRebound(to: UInt32.self, capacity: 1) { intptr in
                UInt32(littleEndian: intptr.pointee)
            }
        }
    }

    public func matchPayToPubkey() -> BitcoinPublicKey? {
        if bytes.count == Bitcoin.publicKeySize + 2 && bytes[0] == Bitcoin.publicKeySize && bytes.last == OpCode.OP_CHECKSIG {
            let pubkeyData = Data(bytes: bytes[bytes.startIndex + 1 ..< bytes.startIndex + Bitcoin.publicKeySize + 1])
            return BitcoinPublicKey(data: pubkeyData)
        }
        if bytes.count == Bitcoin.compressedPublicKeySize + 2 && bytes[0] == Bitcoin.compressedPublicKeySize && bytes.last == OpCode.OP_CHECKSIG {
            let pubkeyData = Data(bytes: bytes[bytes.startIndex + 1 ..< bytes.startIndex + Bitcoin.compressedPublicKeySize + 1])
            return BitcoinPublicKey(data: pubkeyData)
        }
        return nil
    }

    public func matchPayToPubkeyHash() -> Data? {
        if bytes.count == 25 && bytes[0] == OpCode.OP_DUP && bytes[1] == OpCode.OP_HASH160 && bytes[2] == 20 && bytes[23] == OpCode.OP_EQUALVERIFY && bytes[24] == OpCode.OP_CHECKSIG {
            return Data(bytes: bytes[bytes.startIndex + 3 ..< bytes.startIndex + 23])
        }
        return nil
    }

    public func matchMultisig(required: inout Int) -> [BitcoinPublicKey]? {
        if bytes.count < 1 || bytes.last != OpCode.OP_CHECKMULTISIG {
            return []
        }

        var keys = [BitcoinPublicKey]()

        var it = bytes.startIndex
        var opcode = 0 as UInt8
        var contents = Data()
        if !getScriptOp(index: &it, opcode: &opcode, contents: &contents) || !OpCode.isSmallInteger(opcode) {
            return nil
        }
        required = BitcoinScript.decodeNumber(opcode: opcode)
        while getScriptOp(index: &it, opcode: &opcode, contents: &contents), let key = BitcoinPublicKey(data: contents) {
            keys.append(key)
        }
        if !OpCode.isSmallInteger(opcode) {
            return nil
        }

        let expectedCount = BitcoinScript.decodeNumber(opcode: opcode)
        if keys.count != expectedCount || expectedCount < required {
            return nil
        }
        if it + 1 != bytes.endIndex {
            return nil
        }

        return keys
    }

    // MARK: Binary Coding

    public func encode(into data: inout Data) {
        writeCompactSize(bytes.count, into: &data)
        self.data.encode(into: &data)
    }
}
