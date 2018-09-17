// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import SwiftProtobuf

extension TronTransaction {
    public var hasSignature: Bool {
        return signature.count == 1
    }

    public mutating func addSignature(_ signature: Data) {
        self.signature.append(signature)
    }

    public func getSignature() -> Data {
        return self.signature[0]
    }

    public mutating func hash() -> Data {
        return Crypto.sha256(self.rawData.toData())
    }

    public mutating func sign(privateKey: Data) -> Data {
        let signature = Crypto.sign(hash: self.hash(), privateKey: privateKey)
        self.addSignature(signature)
        return signature
    }
}

extension TronTransaction.RawData {
    public func toData() -> Data {
        return try! self.serializedData()
    }
}

extension String {

    /// Create `Data` from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a `Data` object. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.

    public func hexadecimal() -> Data? {
        var data = Data(capacity: characters.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(location: 0, length: utf16.count)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }

        if data.isEmpty {
            return nil
        }

        return data
    }
}

extension Data {

    /// Create hexadecimal string representation of `Data` object.
    ///
    /// - returns: `String` representation of this `Data` object.

    public func hexadecimal() -> String {
        return map { String(format: "%02x", $0) }
            .joined(separator: "")
    }
}

public class TronTransactionBuilder {
    public func build(from: String, to: String, amount: Int64, note: String) -> TronTransaction {
        let contract = TronTransactionContractBuiler()
            .type(.transferContract)
            .parameter(
                from: Crypto.base58Decode(from)!,
                to: Crypto.base58Decode(to)!,
                amount: amount
            )
            .build()

        let rawData = TronTransactionRawDataBuilder()
            .contract(contract)
            .data(note.data(using: .utf8)!)
            .build()

        return TronTransaction(rawData: rawData)
    }

    public init() {}
}

public class TronTransactionRawDataBuilder {
    private var rawData = TronTransaction.RawData()

    public func blockHash(_ blockHash: Data) -> TronTransactionRawDataBuilder {
        rawData.refBlockHash = blockHash
        return self
    }

    public func blockBytes(_ blockBytes: Data) -> TronTransactionRawDataBuilder {
        rawData.refBlockBytes = blockBytes
        return self
    }

    public func blockNumber(_ blockNumber: Int64) -> TronTransactionRawDataBuilder {
        rawData.refBlockNum = blockNumber
        return self
    }

    public func expiration(_ expiration: Int64) -> TronTransactionRawDataBuilder {
        rawData.expiration = expiration
        return self
    }

    public func timestamp(_ timestamp: Int64) -> TronTransactionRawDataBuilder {
        rawData.timestamp = timestamp
        return self
    }

    public func contract(_ contract: TronTransaction.Contract) -> TronTransactionRawDataBuilder {
        rawData.contract.append(contract)
        return self
    }

    public func data(_ data: Data) -> TronTransactionRawDataBuilder {
        rawData.data = data
        return self
    }

    public func build() -> TronTransaction.RawData {
        return rawData
    }
}

public class TronTransactionContractBuiler {
    private var contract = TronTransaction.Contract()

    public func type(_ type: TronTransaction.Contract.ContractType) -> TronTransactionContractBuiler {
        contract.type = type
        return self
    }

    public func parameter(from: Data, to: Data, amount: Int64) -> TronTransactionContractBuiler {
        var transferContract = Protocol_TransferContract()

        transferContract.ownerAddress = from
        transferContract.toAddress = to
        transferContract.amount = amount

        let parameter = try! Google_Protobuf_Any.init(message: transferContract)

        contract.parameter = parameter

        return self
    }

    public func build() -> TronTransaction.Contract {
        return contract
    }
}
