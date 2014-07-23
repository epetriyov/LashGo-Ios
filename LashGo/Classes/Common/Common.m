//
//  Common.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 23.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "Common.h"

static NSString *const kUUIDDeviceKey = @"lg_uuid_device_key";

@implementation NSString (CommonExtension)

@dynamic commonLocalizedString;

#pragma mark - Properties

- (NSString *) commonLocalizedString {
	return NSLocalizedStringFromTable(self, @"Localizable", nil);
}

#pragma mark - Methods

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

#pragma mark -

+ (NSString *) deviceUUID {
	static NSString *deviceID = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		NSString *udid = [userDefaults stringForKey: kUUIDDeviceKey];
		if ([Common isEmpty:udid] == YES) {
			udid = [Common generateUUID];
			[userDefaults setValue:udid forKey:kUUIDDeviceKey];
			[userDefaults synchronize];
		}
		deviceID = udid;
	});
	
	return deviceID;
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

#pragma mark -

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
