#import "FileManager.h"

@implementation FileManager

+ (NSString *) cachesDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if ([paths count] <= 0) {
        return nil;
    }
	NSString *cachesDirectory = [paths objectAtIndex: 0];
	return cachesDirectory;
}

+ (NSString *) documentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if ([paths count] <= 0) {
        return nil;
    }
	NSString *documentsDirectory = [paths objectAtIndex: 0];
	
	return documentsDirectory;
}

#pragma mark -

+ (BOOL) fileExistsAtPath: (NSString *) path {
	return [ [NSFileManager defaultManager] fileExistsAtPath: path];
}

+ (BOOL) createFileAtPath: (NSString *) path withData: (NSData *) data {
	path = [path stringByExpandingTildeInPath];
	BOOL result = [ [NSFileManager defaultManager] createFileAtPath: path contents: data attributes: nil];
	if (result == NO) {
		DLog(@"Save file error: %@", path);
	}
	return result;
}

+ (BOOL) deleteFileAtPath: (NSString *) path {
	path = [path stringByExpandingTildeInPath];
	
	NSError *error = nil;
	
	BOOL result = [ [NSFileManager defaultManager] removeItemAtPath: path error: &error];
	if (result == NO) {
		DLog(@"Delete file error: %@", path);
	}
	return result;
}

+ (BOOL) writeOrCreateProtectedFileAtPath: (NSString *) path withData: (NSData *) data {
	path = [path stringByExpandingTildeInPath];
	
	NSError *error = nil;
	BOOL result = NO;
	
	if ([[NSFileManager defaultManager] fileExistsAtPath: path] == YES) {
		result = [data writeToFile: path options: NSDataWritingFileProtectionComplete error: &error];
	} else {
		result = [ [NSFileManager defaultManager] createFileAtPath: path contents: data attributes: @{NSFileProtectionKey : NSFileProtectionComplete} ];
	}
	
	if (result == NO) {
		DLog(@"Save file error: %@", path);
	}
	return result;
}

#pragma mark -

+ (NSData *) dataWithContentsOfFileAtPath: (NSString *) path {
	path = [path stringByExpandingTildeInPath];
	NSData *data = [NSData dataWithContentsOfFile: path];
	if (data == nil) {
		DLog(@"Read file error at path:\n%@", path);
		return nil;
	}
	return data;
}

@end
