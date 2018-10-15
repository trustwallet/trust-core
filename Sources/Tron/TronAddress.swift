// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit

public struct TronAddress: Address, Hashable {
    public static let size = 20
    
    static public func isValid(data: Data) -> Bool {
        if data.count != TronAddress.size + 1 {
            return false
        }
        
        return true
    }
    
    static public func isValid(string: String) -> Bool {
        guard let decoded = Crypto.base58Decode(string) else {
            return false
        }
        
        if decoded.count != 1 + TronAddress.size {
            return false
        }
        
        return string.hasPrefix("T")
    }
    
    public let data: Data
    
    public init?(data: Data) {
        if !TronAddress.isValid(data: data) {
            return nil
        }
        self.data = data
    }
    
    public init?(string: String) {
        guard let decoded = Crypto.base58Decode(string) else {
            return nil
        }
        self.init(data: decoded)
    }
    
    public var base58String: String {
        return Crypto.base58Encode(data)
    }
    
    public var description: String {
        return base58String
    }
    
    public var hashValue: Int {
        return data.hashValue
    }
    
    public static func == (lhs: TronAddress, rhs: TronAddress) -> Bool {
        return lhs.data == rhs.data
    }
}
