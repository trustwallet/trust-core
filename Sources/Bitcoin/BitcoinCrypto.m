// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "BitcoinCrypto.h"
#import <TrezorCrypto/TrezorCrypto.h>

@implementation BitcoinCrypto

+ (nonnull NSData *)getPublicKeyFrom:(nonnull NSData *)privateKey {
    NSMutableData *publicKey = [[NSMutableData alloc] initWithLength:65];
    ecdsa_get_public_key65(&secp256k1, privateKey.bytes, publicKey.mutableBytes);
    return publicKey;
}

+ (nonnull NSString *)base58Encode:(nonnull NSData *)data {
    size_t size = 0;
    b58enc(nil, &size, data.bytes, data.length);
    size += 16;

    char *cstring = malloc(size);
    size = base58_encode_check(data.bytes, (int)data.length, HASHER_SHA2D, cstring, (int)size);

    return [[NSString alloc] initWithBytesNoCopy:cstring length:size - 1 encoding:NSUTF8StringEncoding freeWhenDone:YES];
}

+ (NSData *)base58Decode:(nonnull NSString *)string expectedSize:(NSInteger)expectedSize {
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];

    NSMutableData *result = [[NSMutableData alloc] initWithLength:expectedSize];
    if (base58_decode_check(str, HASHER_SHA2D, result.mutableBytes, (int)expectedSize) == 0) {
        return nil;
    }

    return result;
}

+ (nonnull NSData *)sha256:(nonnull NSData *)data {
    NSMutableData *result = [[NSMutableData alloc] initWithLength:SHA256_DIGEST_LENGTH];
    sha256_Raw(data.bytes, data.length, result.mutableBytes);
    return result;
}

+ (nonnull NSData *)ripemd160:(nonnull NSData *)data {
    NSMutableData *result = [[NSMutableData alloc] initWithLength:RIPEMD160_DIGEST_LENGTH];
    ripemd160(data.bytes, (uint32_t)data.length, result.mutableBytes);
    return result;
}

+ (nonnull NSData *)sha256sha256:(nonnull NSData *)data {
    return [self sha256:[self sha256:data]];
}

+ (nonnull NSData *)sha256ripemd160:(nonnull NSData *)data {
    return [self ripemd160:[self sha256:data]];
}

@end
