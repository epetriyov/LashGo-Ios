#import "CryptoUtils.h"

@implementation NSString (CryptoExtension)

- (NSString *) md5 {
	const char *cStr = self.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
	
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	
    for(uint i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", result[i]];
	
    return  output;
}

@end

// The chosen symmetric key and digest algorithm chosen for this sample is AES and SHA1.
// The reasoning behind this was due to the fact that the iPhone and iPod touch have
// hardware accelerators for those particular algorithms and therefore are energy efficient.

#define kChosenCipherBlockSize	kCCBlockSizeAES128
#define kChosenCipherKeySize	kCCKeySizeAES128
#define kChosenDigestLength		CC_SHA1_DIGEST_LENGTH
#define kPBKDFRounds 2000		// ~16ms on an iPhone 4

#if DEBUG
	#define LOGGING_FACILITY(X, Y)	\
		NSAssert(X, Y);

	#define LOGGING_FACILITY1(X, Y, Z)	\
		NSAssert1(X, Y, Z);
#else
	#define LOGGING_FACILITY(X, Y)	\
		if (!(X)) {			\
			DLog(Y);		\
		}

	#define LOGGING_FACILITY1(X, Y, Z)	\
		if (!(X)) {				\
			DLog(Y, Z);		\
		}
#endif

@implementation NSData (CryptoExtension)

- (NSString *) md5 {
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5([self bytes], (CC_LONG)[self length], result);
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	
    for(uint i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", result[i]];
	
    return  output;
}

- (NSData *) doCipherOperation: (CCOperation) cryptOperation
						string: (NSString *) string
						  salt: (NSData *) salt {
    LOGGING_FACILITY(salt, @"salt must not be NULL");
    
    NSData *key = [self AESKeyForString: string salt: salt];
    
    size_t outLength;
    NSMutableData * cipherData = [NSMutableData dataWithLength: self.length + kChosenCipherBlockSize];
	
	uint8_t iv[kChosenCipherBlockSize];
	memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    CCCryptorStatus
    result = CCCrypt(cryptOperation,
                     kCCAlgorithmAES128,
                     kCCOptionPKCS7Padding,
                     key.bytes,
                     key.length,
                     (const void *)iv,//CCrfc3394_iv,//iv.bytes
                     self.bytes,
                     self.length,
                     cipherData.mutableBytes,
                     cipherData.length,
                     &outLength);
    
    if (result == kCCSuccess) {
        cipherData.length = outLength;
    } else {
        cipherData = nil;
    }
    
    return cipherData;
}

- (NSData *)AESKeyForString:(NSString *) string
					   salt:(NSData *)salt {
	CCCryptorStatus ccStatus = kCCSuccess;
	
    NSMutableData *derivedKey = [NSMutableData dataWithLength: kChosenCipherKeySize];
    
    ccStatus = CCKeyDerivationPBKDF(kCCPBKDF2,
									string.UTF8String,
									[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
									salt.bytes,
									salt.length,
									kCCPRFHmacAlgSHA1,
									kPBKDFRounds,
									derivedKey.mutableBytes,
									derivedKey.length);
	DLog(@"%d", ccStatus);
    
    return derivedKey;
}

@end
