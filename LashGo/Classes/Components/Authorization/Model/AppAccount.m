//
//  AppAccount.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 12.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "AppAccount.h"
#import "CryptoUtils.h"
#import "FileManager.h"

NSString *const kLastUsedSessionId = @"lg_last_used_session_id";

#define kUserInfoFileName @"UserInfo"

@interface AppAccount () <DataProviderDelegate>

@end

@implementation AppAccount

@dynamic accountSocialName;
@dynamic accountType;
@dynamic accessToken;

- (NSString *) accessToken {
	return nil;
}

#pragma mark - Properties

- (void) setSessionID:(NSString *)sessionID {
	_sessionID = sessionID;
	
	if (sessionID == nil) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey: kLastUsedSessionId];
	} else {
		[[NSUserDefaults standardUserDefaults] setObject: sessionID forKey: kLastUsedSessionId];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Overrides {

- (id) init {
	if (self = [super init]) {
		_sessionID = [[NSUserDefaults standardUserDefaults] stringForKey: kLastUsedSessionId];
		
		_dataProvider = [[DataProvider alloc] init];
		_dataProvider.delegate = self;
		[self restoreData];
	}
	return self;
}

- (void) login {
	
}

- (void) logout {
	
}

- (void) handleApplicationDidBecomeActive {
	
}

- (void) handleApplicationWillTerminate {
	
}

- (BOOL) handleOpenURL:(NSURL *)url
	 sourceApplication:(NSString *)sourceApplication {
	return NO;
}

#pragma mark -

- (void) cleanDataAsync {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString *path = [[FileManager cachesDirectory] stringByAppendingPathComponent: kUserInfoFileName];
		[FileManager deleteFileAtPath: path];
	});
}

- (void) storeDataAsync {
	__weak AppAccount *wself = self;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString *path = [[FileManager cachesDirectory] stringByAppendingPathComponent: kUserInfoFileName];
		[wself archiveObject: wself.userInfo withKey: @"userInfo" toFile: path];
	});
}

- (void) restoreData {
	NSString *path = [[FileManager cachesDirectory] stringByAppendingPathComponent: kUserInfoFileName];
	self.userInfo = (LGUser *)[self readObjectWithKey: @"userInfo" fromFile: path];
}

#pragma mark - Methods for storing

- (BOOL) archiveObject: (id<NSCoding>) obj withKey: (NSString *) key toFile: (NSString*) path {
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData: data];
	archiver.outputFormat = NSPropertyListBinaryFormat_v1_0;
	[archiver encodeObject: obj	forKey: key];
	[archiver finishEncoding];
	
	NSString *cipherKey = [[NSBundle mainBundle] bundleIdentifier];
	NSData *salt = [NSStringFromClass([NSObject class]) dataUsingEncoding: NSUTF8StringEncoding];
	
	NSData *encodedData = [data doCipherOperation: kCCEncrypt string: cipherKey salt: salt];
	
	BOOL rez = [FileManager writeOrCreateProtectedFileAtPath: path withData: encodedData];
	return rez;
}

- (id<NSCoding>) readObjectWithKey: (NSString *) key fromFile: (NSString*) path {
	NSData *encodedData = [FileManager dataWithContentsOfFileAtPath: path];
	
	NSString *cipherKey = [[NSBundle mainBundle] bundleIdentifier];
	NSData *salt = [NSStringFromClass([NSObject class]) dataUsingEncoding: NSUTF8StringEncoding];
	
	NSData *data = [encodedData doCipherOperation: kCCDecrypt string: cipherKey salt: salt];
	
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData: data];
	id<NSCoding> obj = [unarchiver decodeObjectForKey: key];
	[unarchiver finishDecoding];
	
	return obj;
}

#pragma mark - DataProviderDelegate implementation

- (void) dataProvider: (DataProvider *) dataProvider didRegisterUser: (LGRegisterInfo *) registerInfo {
	self.sessionID = registerInfo.sessionInfo.uid;
	self.userInfo = registerInfo.user;
	[self storeDataAsync];
	[self.delegate authDidFinish: YES forAccount: self];
}

- (void) dataProvider: (DataProvider *) dataProvider didFailRegisterUserWith: (NSError *) error {
	[self cleanDataAsync];
	[self.delegate authDidFinish: NO forAccount: self];
}

@end
