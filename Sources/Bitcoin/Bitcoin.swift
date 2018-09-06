// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

/// Bitcoin blockchain.
///
/// Bitcoin-based blockchains should inherit from this class.
open class Bitcoin: Blockchain {
    /// SLIP-044 coin type.
    override open var coinType: Slip {
        return .bitcoin
    }

    /// Public key hash address prefix.
    open var publicKeyHashAddressPrefix: UInt8 {
        return 0x00
    }

    /// Private key prefix.
    open var privateKeyPrefix: UInt8 { return 0x80 }

    /// Pay to script hash (P2SH) address prefix.
    open var payToScriptHashAddressPrefix: UInt8 {
        return 0x05
    }

    open override func address(for publicKey: PublicKey) -> Address {
        return publicKey.bitcoinAddress(prefix: payToScriptHashAddressPrefix)
    }

    open override func address(string: String) -> Address? {
        return BitcoinAddress(string: string)
    }

    open override func address(data: Data) -> Address? {
        return BitcoinAddress(data: data)
    }
}

public final class Litecoin: Bitcoin {
    public override var coinType: Slip {
        return .litecoin
    }

    public override var payToScriptHashAddressPrefix: UInt8 {
        return 0x32
    }
}

public final class Tron: Bitcoin {
    public override var coinType: Slip {
        return .tron
    }
    public override var payToScriptHashAddressPrefix: UInt8 {
        return 0x41
    }
}
