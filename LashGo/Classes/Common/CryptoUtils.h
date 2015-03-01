#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonKeyDerivation.h>

@interface NSString (CryptoExtension)

- (NSString *) md5;

@end

@interface NSData (CryptoExtension)

- (NSString *) hexString;
- (NSString *) md5;
- (NSData *) doCipherOperation: (CCOperation) cryptOperation
						string: (NSString *) string
						  salt: (NSData *) salt;

@end
