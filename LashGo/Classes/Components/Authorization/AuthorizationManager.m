//
//  AuthorizationManager.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 12.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "AuthorizationManager.h"
#import "Common.h"

#import "FacebookAppAccount.h"
#import "TwitterAppAccount.h"

@implementation AuthorizationManager

+ (instancetype) sharedManager {
	SHARED_INSTANCE_WITH_BLOCK(^{
		return [[self alloc] init];
	})
}

#pragma mark - Methods

- (void) loginUsingFacebook {
	if (_account != nil && [_account isKindOfClass: [FacebookAppAccount class]] == NO) {
		[_account logout];
		_account = nil;
	}
	if (_account == nil) {
		_account = [[FacebookAppAccount alloc] init];
		_account.delegate = self;
	}
	[_account login];
}

- (void) loginUsingTwitter {
	if (_account != nil && [_account isKindOfClass: [TwitterAppAccount class]] == NO) {
		[_account logout];
		_account = nil;
	}
	if (_account == nil) {
		_account = [[TwitterAppAccount alloc] init];
		_account.delegate = self;
	}
	[_account login];
}

#pragma mark - AppAccountDelegate implementation

- (void) authDidFinish: (BOOL) success forAccount: (AppAccount *) account {
	if (success == NO && account == _account) {
		_account = nil;
	}
}

@end
