// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct NeoTransaction: BinaryEncoding {
    
    /// Transaction type
    public let type: UInt8
    
    /// Transaction data format version
    public let version: UInt8
    
    public var attributes: [Attribute]
    
    /// A list of 1 or more transaction inputs or sources for coins
    public let inputs: [NeoTransactionInput]
    
    /// A list of 1 or more transaction outputs or destinations for coins
    public let outputs: [NeoTransactionOutput]
    
    public let scripts: [Script]
    
    public init(type: UInt8,
                version: UInt8,
                attributes: [Attribute],
                inputs: [NeoTransactionInput],
                outputs: [NeoTransactionOutput],
                scripts: [Script]){
        self.type = type
        self.version = version
        self.attributes = attributes
        self.inputs = inputs
        self.outputs = outputs
        self.scripts = scripts
    }
    
    public func encode(into data: inout Data) {
        type.encode(into: &data)
        version.encode(into: &data)
        attributes.encode(into: &data)
        inputs.encode(into: &data)
        outputs.encode(into: &data)
        scripts.encode(into: &data)
    }
    
}

public struct NeoTransactionInput: BinaryEncoding {
    //previous hash
    //todo - prevHash must be UInt256
    //mabe use https://github.com/hyugit/UInt256
    //or https://github.com/CryptoCoinSwift/UInt256
    let prevHash: UInt64
    let prevIndx: UInt16
    
    public init(prevHash: UInt64, prevIndx: UInt16){
        self.prevHash = prevHash
        self.prevIndx = prevIndx
    }
    
    public func encode(into data: inout Data) {
        prevHash.encode(into: &data)
        prevIndx.encode(into: &data)
    }
}

public struct NeoTransactionOutput: BinaryEncoding {
    //todo - assetId must be UInt256
    let assetId: UInt64
    let value: Int64
    //Address of remittee
    //todo - scriptHash must be UInt160
    let scriptHash: UInt64
    
    //todo - change assetId type to UInt256, scriptHash - to UInt160
    public init(assetId: UInt64, value: Int64, scriptHash: UInt64){
        self.assetId = assetId
        self.value = value
        self.scriptHash = scriptHash
    }
    
    public func encode(into data: inout Data){
        assetId.encode(into: &data)
        value.encode(into: &data)
        scriptHash.encode(into: &data)
    }
    
}

public struct Attribute: BinaryEncoding {
    let usage: UInt8
    let length: UInt8
    let data: [UInt8]
    
    public init(usage: UInt8, length: UInt8, data: [UInt8]){
        self.usage = usage
        self.length = length
        self.data = data
    }
    
    public func encode(into data: inout Data) {
        usage.encode(into: &data)
        length.encode(into: &data)
        data.encode(into: &data)
    }
}

public struct Script: BinaryEncoding {
    let stackScript: [UInt8]
    let redeemScript: [UInt8]
    
    public init(stackScript: [UInt8], redeemScript: [UInt8]){
        self.stackScript = stackScript
        self.redeemScript = redeemScript
    }
    
    public func encode(into data: inout Data) {
        stackScript.encode(into: &data)
        redeemScript.encode(into: &data)
    }
}


