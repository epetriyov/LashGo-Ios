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
#import "VkontakteAppAccount.h"

NSString *const kAuthorizationNotification = @"SocialLoginNotification";
NSString *const kLastUsedAccountKey = @"lg_last_used_accoun_type";

@implementation AuthorizationManager

+ (instancetype) sharedManager {
	SHARED_INSTANCE_WITH_BLOCK(^{
		return [[self alloc] init];
	})
}

- (id) init {
	if (self = [super init]) {
		AppAccountType accType = (short)[[NSUserDefaults standardUserDefaults] integerForKey: kLastUsedAccountKey];
		switch (accType) {
			case AppAccountTypeFacebook:
				_account = [[FacebookAppAccount alloc] init];
				_account.delegate = self;
				break;
			case AppAccountTypeVkontakte:
				_account = [[VkontakteAppAccount alloc] init];
				_account.delegate = self;
				break;
			default:
				break;
		}
	}
	return self;
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

- (void) loginUsingTwitterFromView: (UIView *) loginView {
	if (_account != nil && [_account isKindOfClass: [TwitterAppAccount class]] == NO) {
		[_account logout];
		_account = nil;
	}
	if (_account == nil) {
		TwitterAppAccount *account = [[TwitterAppAccount alloc] init];
		account.delegate = self;
		account.selectAccountParentView = loginView;
		_account = account;
	}
	[_account login];
}

- (void) loginUsingVkontakte {
	if (_account != nil && [_account isKindOfClass: [VkontakteAppAccount class]] == NO) {
		[_account logout];
		_account = nil;
	}
	if (_account == nil) {
		_account = [[VkontakteAppAccount alloc] init];
		_account.delegate = self;
	}
	[_account login];
}

#pragma mark - AppAccountDelegate implementation

- (void) authDidFinish: (BOOL) success forAccount: (AppAccount *) account {
	if (account == _account) {
		NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
		if (success == NO) {
			_account = nil;
			[defs removeObjectForKey: kLastUsedAccountKey];
		} else {
			[defs setInteger: account.accountType forKey: kLastUsedAccountKey];
		}
		[defs synchronize];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName: kAuthorizationNotification object: nil];
	
}

@end
