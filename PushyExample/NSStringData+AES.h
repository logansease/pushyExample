@interface NSData (AES)

-(NSData *) aesEncryptedDataWithKey:(NSData *) key;
@end

@interface NSString (AES)

- (NSData *) sha256;
@end