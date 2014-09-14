//
//  LashGoAppAccount.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 13.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LashGoAppAccount.h"
#import "CryptoUtils.h"
#import "DataProvider.h"
#import "FileManager.h"

#define kLoginInfoFileName @"LoginInfo"

@interface LashGoAppAccount () <DataProviderDelegate> {
	DataProvider *_dataProvider;
}

@end

@implementation LashGoAppAccount

#pragma mark - Properties

- (NSString *) accountSocialName {
	return @"lashgo";
}

- (AppAccountType) accountType {
	return AppAccountTypeLashGo;
}

- (NSString *) accessToken {
	return nil;
}

#pragma mark - Standard overrides

- (id) init {
	if (self = [super init]) {
		_dataProvider = [[DataProvider alloc] init];
		_dataProvider.delegate = self;
		[self restoreData];
	}
	return self;
}

#pragma mark - Methods

- (void) login {
	[_dataProvider userLogin: self.loginInfo];
}

- (void) logout {
	[self cleanDataAsync];
}

- (void) registerAccount {
	[_dataProvider userRegister: self.loginInfo];
}

#pragma mark -

- (void) cleanDataAsync {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString *path = [[FileManager cachesDirectory] stringByAppendingPathComponent: kLoginInfoFileName];
		[FileManager deleteFileAtPath: path];
	});
}

- (void) storeDataAsync {
	__weak LashGoAppAccount *wself = self;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString *path = [[FileManager cachesDirectory] stringByAppendingPathComponent: kLoginInfoFileName];
		[wself archiveObject: wself.loginInfo withKey: @"loginInfo" toFile: path];
	});
}

- (void) restoreData {
	NSString *path = [[FileManager cachesDirectory] stringByAppendingPathComponent: kLoginInfoFileName];
	self.loginInfo = (LGLoginInfo *)[self readObjectWithKey: @"loginInfo" fromFile: path];
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
