// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public extension BitcoinScript {
    /// Returns a single operation at the given index including its operand.
    ///
    /// - Parameters:
    ///   - index: index where the operation starts, on return the index of the next operation.
    /// - Returns: a tuple with the opcode and its operand or `nil` if's the end of the script or the script is invalid.
    func getScriptOp(index: inout Int) -> (opcode: UInt8, operand: Data?)? {
        // Read instruction
        if index >= bytes.endIndex {
            return nil
        }

        let opcode = bytes[index]
        index += 1

        if opcode > OpCode.OP_PUSHDATA4 {
            return (opcode: opcode, operand: nil)
        }

        // Immediate operand
        var size = 0
        if opcode < OpCode.OP_PUSHDATA1 {
            size = Int(opcode)
        } else if opcode == OpCode.OP_PUSHDATA1 {
            if bytes.endIndex - index < 1 {
                return nil
            }
            size = index
            index += 1
        } else if opcode == OpCode.OP_PUSHDATA2 {
            if bytes.endIndex - index < 2 {
                return nil
            }
            size = Int(readLE16(at: index))
            index += 2
        } else if opcode == OpCode.OP_PUSHDATA4 {
            if bytes.endIndex - index < 4 {
                return nil
            }
            size = Int(readLE32(at: index))
            index += 4
        }
        if bytes.endIndex - index < size {
            return nil
        }
        index += size

        return (opcode: opcode, operand: data[index ..< index + size])
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
}
