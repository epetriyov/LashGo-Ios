//
//  LashGoAppAccount.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 13.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LashGoAppAccount.h"

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

#pragma mark - Methods

- (void) login {
	[_dataProvider userLogin: self.loginInfo];
}

- (void) logout {
	[self cleanDataAsync];
	[self.delegate logoutFinishedForAccount: self];
}

- (void) registerAccount {
	[_dataProvider userRegister: self.loginInfo];
}

@end
