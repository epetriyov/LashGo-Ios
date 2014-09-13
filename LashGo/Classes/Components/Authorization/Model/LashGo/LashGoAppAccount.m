//
//  LashGoAppAccount.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 13.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LashGoAppAccount.h"
#import "DataProvider.h"

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
	}
	return self;
}

#pragma mark - Methods

- (void) login {
	[_dataProvider userLogin: self.loginInfo];
}

- (void) registerAccount {
	[_dataProvider userRegister: self.loginInfo];
}

#pragma mark - DataProviderDelegate implementation

- (void) dataProvider: (DataProvider *) dataProvider didRegisterUser: (LGRegisterInfo *) registerInfo {
	self.sessionID = registerInfo.sessionInfo.uid;
	self.userInfo = registerInfo.user;
	[self.delegate authDidFinish: YES forAccount: self];
}

- (void) dataProvider: (DataProvider *) dataProvider didFailRegisterUserWith: (NSError *) error {
	[self.delegate authDidFinish: NO forAccount: self];
}

@end
