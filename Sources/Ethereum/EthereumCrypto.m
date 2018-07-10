// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "EthereumCrypto.h"
#import <TrezorCrypto/TrezorCrypto.h>

@implementation EthereumCrypto

+ (nonnull NSData *)getPublicKeyFrom:(nonnull NSData *)privateKey {
    NSMutableData *publicKey = [[NSMutableData alloc] initWithLength:65];
    ecdsa_get_public_key65(&secp256k1, privateKey.bytes, publicKey.mutableBytes);
    return publicKey;
}

+ (nonnull NSData *)hash:(nonnull NSData *)hash {
    NSMutableData *output = [[NSMutableData alloc] initWithLength:sha3_256_hash_size];
    keccak_256(hash.bytes, hash.length, output.mutableBytes);
    return output;
}

+ (nonnull NSData *)signHash:(nonnull NSData *)hash privateKey:(nonnull NSData *)privateKey {
    NSMutableData *signature = [[NSMutableData alloc] initWithLength:65];
    uint8_t by = 0;
    ecdsa_sign_digest(&secp256k1, privateKey.bytes, hash.bytes, signature.mutableBytes, &by, nil);
    ((uint8_t *)signature.mutableBytes)[64] = by;
    return signature;
}

+ (BOOL)verifySignature:(nonnull NSData *)signature message:(nonnull NSData *)message publicKey:(nonnull NSData *)publicKey {
    return ecdsa_verify_digest(&secp256k1, publicKey.bytes, signature.bytes, message.bytes) == 0;
}

@end
