// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public indirect enum ABIType: Equatable, CustomStringConvertible {
    /// Unsigned integer with `0 < bits <= 256`, `bits % 8 == 0`
    case uint(bits: Int)

    /// Signed integer with `0 < bits <= 256`, `bits % 8 == 0`
    case int(bits: Int)

    /// Address, similar to `uint(bits: 160)`
    case address

    /// Boolean
    case bool

    /// Signed fixed-point decimal number of M bits, `8 <= M <= 256`, `M % 8 == 0`, and `0 < N <= 80`, which denotes the value `v` as `v / (10 ** N)`
    case fixed(Int, Int)

    /// Unsigned fixed-point decimal number of M bits, `8 <= M <= 256`, `M % 8 == 0`, and `0 < N <= 80`, which denotes the value `v` as `v / (10 ** N)`
    case ufixed(Int, Int)

    /// Binary type of `M` bytes, `0 < M <= 32`.
    case bytes(Int)

    /// An address (20 bytes) followed by a function selector (4 bytes). Encoded identical to `bytes(24)`.
    case function(Function)

    /// Fixed-length array of M elements, `M > 0`, of the given type.
    case array(ABIType, Int)

    /// Dynamic-sized byte sequence
    case dynamicBytes

    /// Dynamic-sized string
    case string

    /// Variable-length array of elements of the given type
    case dynamicArray(ABIType)

    /// Tuple consisting of elements of the given types
    case tuple([ABIType])

    /// Type description
    ///
    /// This is the string as required for function selectors
    public var description: String {
        switch self {
        case .uint(let bits):
            return "uint\(bits)"
        case .int(let bits):
            return "int\(bits)"
        case .address:
            return "address"
        case .bool:
            return "bool"
        case .fixed(let m, let n):
            return "fixed\(m)x\(n)"
        case .ufixed(let m, let n):
            return "ufixed\(m)x\(n)"
        case .bytes(let size):
            return "bytes\(size)"
        case .function(let f):
            return f.description
        case .array(let type, let size):
            return "\(type)[\(size)]"
        case .dynamicBytes:
            return "bytes"
        case .string:
            return "string"
        case .dynamicArray(let type):
            return "\(type)[]"
        case .tuple(let types):
            return types.reduce("", { $0 + $1.description })
        }
    }

    /// Encoded length in bytes, or `nil` for dynamic types
    public var length: Int? {
        switch self {
        case .uint, .int, .address, .bool, .fixed, .ufixed:
            return 32
        case .bytes(let count):
            return ((count + 31) / 32) * 32
        case .function(let f):
            let maybeSum = f.parameters.reduce(0 as Int?) {
                guard let previous = $0, let current = $1.length else {
                    return nil
                }
                return previous + current
            }
            guard let sum = maybeSum else {
                return nil
            }
            return 4 + sum
        case .array(let type, let count):
            guard let typeLength = type.length else {
                return nil
            }
            return typeLength * count
        case .dynamicBytes:
            return nil
        case .string:
            return nil
        case .dynamicArray:
            return nil
        case .tuple(let array):
            let maybeSum = array.reduce(0 as Int?) {
                guard let previous = $0, let current = $1.length else {
                    return nil
                }
                return previous + current
            }
            return maybeSum
        }
    }

    /// Whether the type is dynamic
    public var isDynamic: Bool {
        switch self {
        case .uint, .int, .address, .bool, .fixed, .ufixed, .bytes, .array:
            return false
        case .dynamicBytes, .string, .dynamicArray:
            return true
        case .function(let f):
            return f.parameters.contains(where: { $0.isDynamic })
        case .tuple(let array):
            return array.contains(where: { $0.isDynamic })
        }
    }
}
