// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

@import Foundation;

@interface BitcoinCrypto : NSObject

/// Extracts the public key from a private key.
+ (nonnull NSData *)getPublicKeyFrom:(nonnull NSData *)privateKey NS_SWIFT_NAME(getPublicKey(from:));

/// Encodes data as a base 58 string.
+ (nonnull NSString *)base58Encode:(nonnull NSData *)data NS_SWIFT_NAME(base58Encode(_:));

/// Decodes a base 58 string.
+ (nullable NSData *)base58Decode:(nonnull NSString *)string expectedSize:(NSInteger)expectedSize NS_SWIFT_NAME(base58Decode(_:expectedSize:));

/// Computes the SHA256 hash of the SHA256 hash of the data.
+ (nonnull NSData *)sha256sha256:(nonnull NSData *)data;

/// Computes the RIPEMD-160 hash of the SHA256 hash of the data.
+ (nonnull NSData *)sha256ripemd160:(nonnull NSData *)data;

@end
