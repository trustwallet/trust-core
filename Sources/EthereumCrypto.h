// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

@import Foundation;
@import TrezorCrypto;

@interface EthereumCrypto : NSObject

/// Extracts the public key from a private key.
+ (nonnull NSData *)getPublicKeyFrom:(nonnull NSData *)privateKey NS_SWIFT_NAME(getPublicKey(from:));

/// Computes the Ethereum hash of a block of data (SHA3 Keccak 256 version).
+ (nonnull NSData *)hash:(nonnull NSData *)hash;

/// Signs a hash with a private key.
///
/// @param hash hash to sign
/// @param privateKey private key to use for signing
/// @return signature is in the 65-byte [R || S || V] format where V is 0 or 1.
+ (nonnull NSData *)signHash:(nonnull NSData *)hash privateKey:(nonnull NSData *)privateKey NS_SWIFT_NAME(sign(hash:privateKey:));

/// Verifies a hash signature.
///
/// @param signature signature to verify
/// @param message message to verify
/// @param publicKey public key to verify with
/// @return whether the signature is valid
+ (BOOL)verifySignature:(nonnull NSData *)signature message:(nonnull NSData *)message publicKey:(nonnull NSData *)publicKey NS_SWIFT_NAME(verify(signature:message:publicKey:));

@end
