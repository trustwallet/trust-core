// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "Crypto.h"
#import <TrezorCrypto/TrezorCrypto.h>

@implementation Crypto

// MARK: - Elliptic Curve Cryptography

+ (nonnull NSData *)getPublicKeyFrom:(nonnull NSData *)privateKey {
    NSMutableData *publicKey = [[NSMutableData alloc] initWithLength:65];
    ecdsa_get_public_key65(&secp256k1, privateKey.bytes, publicKey.mutableBytes);
    return publicKey;
}

+ (nonnull NSData *)getCompressedPublicKeyFrom:(nonnull NSData *)privateKey {
    NSMutableData *publicKey = [[NSMutableData alloc] initWithLength:33];
    ecdsa_get_public_key33(&secp256k1, privateKey.bytes, publicKey.mutableBytes);
    return publicKey;
}

+ (nonnull NSData *)getED25519PublicKey:(nonnull NSData *)privateKey {
    NSMutableData *publicKey = [[NSMutableData alloc] initWithLength:32];
    ed25519_publickey(privateKey.bytes, publicKey.mutableBytes);
    return publicKey;
}

+ (nonnull NSData *)signHash:(nonnull NSData *)hash privateKey:(nonnull NSData *)privateKey {
    NSMutableData *signature = [[NSMutableData alloc] initWithLength:65];
    uint8_t by = 0;
    ecdsa_sign_digest(&secp256k1, privateKey.bytes, hash.bytes, signature.mutableBytes, &by, nil);
    ((uint8_t *)signature.mutableBytes)[64] = by;
    return signature;
}

+ (nonnull NSData *)signAsDERHash:(nonnull NSData *)hash privateKey:(nonnull NSData *)privateKey {
    NSMutableData *signature = [[NSMutableData alloc] initWithLength:64];
    NSMutableData *der = [[NSMutableData alloc] initWithLength:72];
    ecdsa_sign_digest(&secp256k1, privateKey.bytes, hash.bytes, signature.mutableBytes, nil, nil);
    int len = ecdsa_sig_to_der(signature.bytes, der.mutableBytes);
    [der setLength:len];
    return der;
}

+ (BOOL)verifySignature:(nonnull NSData *)signature message:(nonnull NSData *)message publicKey:(nonnull NSData *)publicKey {
    return ecdsa_verify_digest(&secp256k1, publicKey.bytes, signature.bytes, message.bytes) == 0;
}

+ (nullable NSData *)recoverPubkeyFrom:(nonnull NSData *)signature message:(nonnull NSData *)message
{
    uint8_t pubkey[65];
    const uint8_t* bytes = (const uint8_t*)[signature bytes];
    uint8_t v = bytes[64];
    if (v >= 27) {
        v -= 27;
    }
    if (ecdsa_recover_pub_from_sig(&secp256k1, pubkey, bytes, message.bytes, v) != 0) {
        return nil;
    }
    return [NSData dataWithBytes:pubkey length:65];
}

// MARK: - Hash functions

+ (nonnull NSData *)hash:(nonnull NSData *)hash {
    NSMutableData *output = [[NSMutableData alloc] initWithLength:sha3_256_hash_size];
    keccak_256(hash.bytes, hash.length, output.mutableBytes);
    return output;
}

+ (nonnull NSData *)sha3_256:(nonnull NSData *)hash {
    NSMutableData *output = [[NSMutableData alloc] initWithLength:sha3_256_hash_size];
    sha3_256(hash.bytes, hash.length, output.mutableBytes);
    return output;
}

+ (nonnull NSData *)sha256:(nonnull NSData *)data {
    NSMutableData *result = [[NSMutableData alloc] initWithLength:SHA256_DIGEST_LENGTH];
    sha256_Raw(data.bytes, data.length, result.mutableBytes);
    return result;
}

+ (nonnull NSData *)blake2b256:(nonnull NSData *)hash {
    NSMutableData *output = [[NSMutableData alloc] initWithLength:32];
    blake2b(hash.bytes, (uint32_t)hash.length, output.mutableBytes, output.length);
    return output;
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

// MARK: - Base58

+ (nonnull NSString *)base58Encode:(nonnull NSData *)data {
    size_t size = 0;
    b58enc(nil, &size, data.bytes, data.length);
    size += 16;

    char *cstring = malloc(size);
    size = base58_encode_check(data.bytes, (int)data.length, HASHER_SHA2D, cstring, (int)size);

    return [[NSString alloc] initWithBytesNoCopy:cstring length:size - 1 encoding:NSUTF8StringEncoding freeWhenDone:YES];
}

+ (nonnull NSString *)base58EncodeRaw:(nonnull NSData *)data {
    size_t size = 0;
    bool success = b58enc(nil, &size, data.bytes, data.length);
    char *cstring = malloc(size);
    success = b58enc(cstring, &size, data.bytes, data.length);
    return [[NSString alloc] initWithBytesNoCopy:cstring length:size - 1 encoding:NSUTF8StringEncoding freeWhenDone:YES];
}

+ (NSData *)base58Decode:(nonnull NSString *)string {
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];

    size_t capacity = 128;
    NSMutableData *result = [[NSMutableData alloc] initWithLength:capacity];

    int size = base58_decode_check(str, HASHER_SHA2D, result.mutableBytes, (int)capacity);
    if (size == 0) {
        return nil;
    }

    [result setLength:size];
    return result;
}

+ (nullable NSData *)base58DecodeRaw:(nonnull NSString *)string
{
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    size_t len = string.length + 4;
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:len];
    if (b58tobin(data.mutableBytes, &len, str) != true) {
        return nil;
    }
    [data setLength:len];
    return data;
}

// MARK: - Bech32

+ (nonnull NSString *)bech32Encode:(nonnull NSData *)data hrp:(nonnull NSString *)hrp
{
    NSMutableData *result = [[NSMutableData alloc] initWithCapacity:89];
    bech32_encode(result.mutableBytes, hrp.UTF8String, data.bytes, data.length);
    return [NSString stringWithUTF8String:result.bytes];
}

+ (nullable NSData *)bech32Decode:(nonnull NSString *)string hrp:(NSString * _Nullable *)hrp
{
    uint8_t data[82];
    char hrpBuf[84];
    size_t dataLen;
    if (1 != bech32_decode(hrpBuf, data, &dataLen, string.UTF8String)) {
        return nil;
    };
    if (hrp) {
        *hrp = [NSString stringWithUTF8String:hrpBuf];
    }
    return [NSData dataWithBytes:data length:dataLen];
}

// MARK: - HDWallet

+ (nonnull NSString *)generateMnemonicWithStrength:(NSInteger)strength {
    const char *cstring = mnemonic_generate((int)strength);
    return [[NSString alloc] initWithCString:cstring encoding:NSUTF8StringEncoding];
}

+ (nonnull NSString *)generateMnemonicFromSeed:(nonnull NSData *)seed {
    const char *cstring = mnemonic_from_data(seed.bytes, (int)seed.length);
    return [[NSString alloc] initWithCString:cstring encoding:NSUTF8StringEncoding];
}

+ (nonnull NSData *)deriveSeedFromMnemonic:(nonnull NSString *)mnemonic passphrase:(nonnull NSString *)passphrase {
    uint8_t seed[512 / 8];
    mnemonic_to_seed([mnemonic cStringUsingEncoding:NSUTF8StringEncoding], [passphrase cStringUsingEncoding:NSUTF8StringEncoding], seed, nil);
    return [[NSData alloc] initWithBytes:seed length:512 / 8];
}

+ (BOOL)isValidMnemonic:(nonnull NSString *)mnemonic {
    return mnemonic_check([mnemonic cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
