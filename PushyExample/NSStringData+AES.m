#import "NSStringData+AES.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSData(AES)


-(NSData *) aesEncryptedDataWithKey:(NSData *) key {
    unsigned char               *buffer = nil;
    size_t                      bufferSize;
    CCCryptorStatus             err;
    NSUInteger                  i, keyLength, plainTextLength;
    
    // make sure there's data to encrypt
    err = ( plainTextLength = [self length] ) == 0;
    
    // pass the user's passphrase through SHA256 to obtain 32 bytes
    // of key data.  Use all 32 bytes for an AES256 key or just the
    // first 16 for AES128.
    if ( ! err ) {
        switch ( ( keyLength = [key length] ) ) {
            case kCCKeySizeAES128:
            case kCCKeySizeAES256:                      break;
                
                // invalid key size
            default:                    err = 1;        break;
        }
    }
    
    // create an output buffer with room for pad bytes
    if ( ! err ) {
        bufferSize = kCCBlockSizeAES128 + plainTextLength + kCCBlockSizeAES128;     // iv + cipher + padding
        
        err = ! ( buffer = (unsigned char *) malloc( bufferSize ) );
    }
    
    // encrypt the data
    if ( ! err ) {
        srandomdev();
        
        // generate a random iv and prepend it to the output buffer.  the
        // decryptor needs to be aware of this.
        for ( i = 0; i < kCCBlockSizeAES128; ++i ) buffer[ i ] = random() & 0xff;
        
        err = CCCrypt( kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                      [key bytes], keyLength, buffer, [self bytes], plainTextLength,
                      buffer + kCCBlockSizeAES128, bufferSize - kCCBlockSizeAES128, &bufferSize );
    }
    
    if ( err ) {
        if ( buffer ) free( buffer );
        
        return nil;
    }
    
    // dataWithBytesNoCopy takes ownership of buffer and will free() it
    // when the NSData object that owns it is released.
    return [NSData dataWithBytesNoCopy: buffer length: bufferSize + kCCBlockSizeAES128];
}


@end

@implementation NSString(AES)
- (NSData *) sha256 {
    unsigned char               *buffer;
    
    if ( ! ( buffer = (unsigned char *) malloc( CC_SHA256_DIGEST_LENGTH ) ) ) return nil;
    
    CC_SHA256( [self UTF8String], [self lengthOfBytesUsingEncoding: NSUTF8StringEncoding], buffer );
    
    return [NSData dataWithBytesNoCopy: buffer length: CC_SHA256_DIGEST_LENGTH];
}
@end