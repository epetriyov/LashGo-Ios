
@interface FileManager : NSObject

+ (NSString *) cachesDirectory;
+ (NSString *) documentsDirectory;

+ (BOOL) fileExistsAtPath: (NSString *) path;
+ (BOOL) createFileAtPath: (NSString *) path withData: (NSData *) data;
+ (BOOL) deleteFileAtPath: (NSString *) path;
+ (BOOL) writeOrCreateProtectedFileAtPath: (NSString *) path withData: (NSData *) data;

+ (NSData *) dataWithContentsOfFileAtPath: (NSString *) path;

@end
