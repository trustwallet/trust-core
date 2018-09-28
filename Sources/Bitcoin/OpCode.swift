// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public enum OpCode {
    // push value
    public static let OP_0 = 0x00 as UInt8
    public static let OP_FALSE = OP_0
    public static let OP_PUSHDATA1 = 0x4c as UInt8
    public static let OP_PUSHDATA2 = 0x4d as UInt8
    public static let OP_PUSHDATA4 = 0x4e as UInt8
    public static let OP_1NEGATE = 0x4f as UInt8
    public static let OP_RESERVED = 0x50 as UInt8
    public static let OP_1 = 0x51 as UInt8
    public static let OP_TRUE = OP_1
    public static let OP_2 = 0x52 as UInt8
    public static let OP_3 = 0x53 as UInt8
    public static let OP_4 = 0x54 as UInt8
    public static let OP_5 = 0x55 as UInt8
    public static let OP_6 = 0x56 as UInt8
    public static let OP_7 = 0x57 as UInt8
    public static let OP_8 = 0x58 as UInt8
    public static let OP_9 = 0x59 as UInt8
    public static let OP_10 = 0x5a as UInt8
    public static let OP_11 = 0x5b as UInt8
    public static let OP_12 = 0x5c as UInt8
    public static let OP_13 = 0x5d as UInt8
    public static let OP_14 = 0x5e as UInt8
    public static let OP_15 = 0x5f as UInt8
    public static let OP_16 = 0x60 as UInt8

    // control
    public static let OP_NOP = 0x61 as UInt8
    public static let OP_VER = 0x62 as UInt8
    public static let OP_IF = 0x63 as UInt8
    public static let OP_NOTIF = 0x64 as UInt8
    public static let OP_VERIF = 0x65 as UInt8
    public static let OP_VERNOTIF = 0x66 as UInt8
    public static let OP_ELSE = 0x67 as UInt8
    public static let OP_ENDIF = 0x68 as UInt8
    public static let OP_VERIFY = 0x69 as UInt8
    public static let OP_RETURN = 0x6a as UInt8

    // stack ops
    public static let OP_TOALTSTACK = 0x6b as UInt8
    public static let OP_FROMALTSTACK = 0x6c as UInt8
    public static let OP_2DROP = 0x6d as UInt8
    public static let OP_2DUP = 0x6e as UInt8
    public static let OP_3DUP = 0x6f as UInt8
    public static let OP_2OVER = 0x70 as UInt8
    public static let OP_2ROT = 0x71 as UInt8
    public static let OP_2SWAP = 0x72 as UInt8
    public static let OP_IFDUP = 0x73 as UInt8
    public static let OP_DEPTH = 0x74 as UInt8
    public static let OP_DROP = 0x75 as UInt8
    public static let OP_DUP = 0x76 as UInt8
    public static let OP_NIP = 0x77 as UInt8
    public static let OP_OVER = 0x78 as UInt8
    public static let OP_PICK = 0x79 as UInt8
    public static let OP_ROLL = 0x7a as UInt8
    public static let OP_ROT = 0x7b as UInt8
    public static let OP_SWAP = 0x7c as UInt8
    public static let OP_TUCK = 0x7d as UInt8

    // splice ops
    public static let OP_CAT = 0x7e as UInt8
    public static let OP_SUBSTR = 0x7f as UInt8
    public static let OP_LEFT = 0x80 as UInt8
    public static let OP_RIGHT = 0x81 as UInt8
    public static let OP_SIZE = 0x82 as UInt8

    // bit logic
    public static let OP_INVERT = 0x83 as UInt8
    public static let OP_AND = 0x84 as UInt8
    public static let OP_OR = 0x85 as UInt8
    public static let OP_XOR = 0x86 as UInt8
    public static let OP_EQUAL = 0x87 as UInt8
    public static let OP_EQUALVERIFY = 0x88 as UInt8
    public static let OP_RESERVED1 = 0x89 as UInt8
    public static let OP_RESERVED2 = 0x8a as UInt8

    // numeric
    public static let OP_1ADD = 0x8b as UInt8
    public static let OP_1SUB = 0x8c as UInt8
    public static let OP_2MUL = 0x8d as UInt8
    public static let OP_2DIV = 0x8e as UInt8
    public static let OP_NEGATE = 0x8f as UInt8
    public static let OP_ABS = 0x90 as UInt8
    public static let OP_NOT = 0x91 as UInt8
    public static let OP_0NOTEQUAL = 0x92 as UInt8

    public static let OP_ADD = 0x93 as UInt8
    public static let OP_SUB = 0x94 as UInt8
    public static let OP_MUL = 0x95 as UInt8
    public static let OP_DIV = 0x96 as UInt8
    public static let OP_MOD = 0x97 as UInt8
    public static let OP_LSHIFT = 0x98 as UInt8
    public static let OP_RSHIFT = 0x99 as UInt8

    public static let OP_BOOLAND = 0x9a as UInt8
    public static let OP_BOOLOR = 0x9b as UInt8
    public static let OP_NUMEQUAL = 0x9c as UInt8
    public static let OP_NUMEQUALVERIFY = 0x9d as UInt8
    public static let OP_NUMNOTEQUAL = 0x9e as UInt8
    public static let OP_LESSTHAN = 0x9f as UInt8
    public static let OP_GREATERTHAN = 0xa0 as UInt8
    public static let OP_LESSTHANOREQUAL = 0xa1 as UInt8
    public static let OP_GREATERTHANOREQUAL = 0xa2 as UInt8
    public static let OP_MIN = 0xa3 as UInt8
    public static let OP_MAX = 0xa4 as UInt8

    public static let OP_WITHIN = 0xa5 as UInt8

    // crypto
    public static let OP_RIPEMD160 = 0xa6 as UInt8
    public static let OP_SHA1 = 0xa7 as UInt8
    public static let OP_SHA256 = 0xa8 as UInt8
    public static let OP_HASH160 = 0xa9 as UInt8
    public static let OP_HASH256 = 0xaa as UInt8
    public static let OP_CODESEPARATOR = 0xab as UInt8
    public static let OP_CHECKSIG = 0xac as UInt8
    public static let OP_CHECKSIGVERIFY = 0xad as UInt8
    public static let OP_CHECKMULTISIG = 0xae as UInt8
    public static let OP_CHECKMULTISIGVERIFY = 0xaf as UInt8

    // expansion
    public static let OP_NOP1 = 0xb0 as UInt8
    public static let OP_CHECKLOCKTIMEVERIFY = 0xb1 as UInt8
    public static let OP_NOP2 = OP_CHECKLOCKTIMEVERIFY as UInt8
    public static let OP_CHECKSEQUENCEVERIFY = 0xb2 as UInt8
    public static let OP_NOP3 = OP_CHECKSEQUENCEVERIFY as UInt8
    public static let OP_NOP4 = 0xb3 as UInt8
    public static let OP_NOP5 = 0xb4 as UInt8
    public static let OP_NOP6 = 0xb5 as UInt8
    public static let OP_NOP7 = 0xb6 as UInt8
    public static let OP_NOP8 = 0xb7 as UInt8
    public static let OP_NOP9 = 0xb8 as UInt8
    public static let OP_NOP10 = 0xb9 as UInt8

    public static let OP_INVALIDOPCODE = 0xff as UInt8

    // Test for "small positive integer" script opcodes - OP_1 through OP_16.
    public static func isSmallInteger(_ opcode: UInt8) -> Bool {
        return opcode >= OP_1 && opcode <= OP_16
    }
}
