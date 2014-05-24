#import <CommonCrypto/CommonDigest.h>

@interface NSString (CryptoExtension)

- (NSString *) md5;

@end

@interface NSData (CryptoExtension)

- (NSString *) md5;

@end
