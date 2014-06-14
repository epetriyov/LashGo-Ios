//
//  Common.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 23.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "Common.h"

@implementation NSString (CommonExtension)

+ (NSString *) stringWithData: (NSData *) data {
	return [ [NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
}

- (NSString *) stringBetweenString:(NSString*)start
						 andString:(NSString*)end {
	NSScanner* scanner = [NSScanner scannerWithString: self];
	[scanner setCharactersToBeSkipped:nil];
	[scanner scanUpToString:start intoString:NULL];
	if ([scanner scanString:start intoString:NULL]) {
		NSString* result = nil;
		if ([scanner scanUpToString:end intoString:&result]) {
			return result;
		}
	}
	return nil;
}

@end

@implementation Common

+ (NSString *) appBuild {
	return [ [ [NSBundle mainBundle] infoDictionary] valueForKey: @"CFBundleVersion"];
}

+ (NSString *) appVersion {
	return [ [ [NSBundle mainBundle] infoDictionary] valueForKey: @"CFBundleShortVersionString"];
}

+ (NSString *) generateUUID {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef str = CFUUIDCreateString(NULL, uuid);
	NSString *result = [NSString stringWithString: (__bridge NSString *) str];
	CFRelease(uuid);
	CFRelease(str);
	
	return result;
}

+ (NSString *) generateUniqueString {
	NSMutableString *result = [NSMutableString stringWithString: [Common generateUUID]];
	[result replaceOccurrencesOfString: @"-" withString: @"" options: NSLiteralSearch
								 range: NSMakeRange(0, [result length]) ];
	return result;
}

+ (BOOL) isEmpty: (NSString *) string {
	if (string != nil &&
		[[string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]
		 isEqualToString: @""] == NO) {
		return NO;
	} else {
		return YES;
	}
}

@end
