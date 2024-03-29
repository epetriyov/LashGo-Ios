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
#import "LashGoAppAccount.h"
#import "TwitterAppAccount.h"
#import "VkontakteAppAccount.h"

NSString *const kAuthorizationNotification = @"SocialLoginNotification";
NSString *const kLastUsedAccountKey = @"lg_last_used_account_type";

@implementation AuthorizationManager

#pragma mark - Overrides

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
			case AppAccountTypeLashGo:
				_account = [[LashGoAppAccount alloc] init];
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

- (void) prepareAccountOfClass: (Class) class {
	if (_account != nil && [_account isKindOfClass: class] == NO) {
		[_account logout];
		_account = nil;
	}
	if (_account == nil) {
		_account = [[class alloc] init];
		_account.delegate = self;
	}
}

- (void) loginUsingFacebook {
	[self prepareAccountOfClass: [FacebookAppAccount class]];
	[_account login];
}

- (void) loginUsingLashGo: (LGLoginInfo *) loginInfo {
	[self prepareAccountOfClass: [LashGoAppAccount class]];
	((LashGoAppAccount *)_account).loginInfo = loginInfo;
	[_account login];
}

- (void) loginUsingTwitterFromViewController: (UIViewController *) loginViewController {
	[self prepareAccountOfClass: [TwitterAppAccount class]];
	((TwitterAppAccount *)_account).presentingViewController = loginViewController;
	[_account login];
}

- (void) loginUsingVkontakteFromViewController: (UIViewController *) loginViewController {
	[self prepareAccountOfClass: [VkontakteAppAccount class]];
	((VkontakteAppAccount *)_account).presentingViewController = loginViewController;
	[_account login];
}

- (void) registerUsingLashGo: (LGLoginInfo *) loginInfo {
	[self prepareAccountOfClass: [LashGoAppAccount class]];
	LashGoAppAccount *account = (LashGoAppAccount *)_account;
	
	account.loginInfo = loginInfo;
	[account registerAccount];
}

#pragma mark - AppAccountDelegate implementation

- (void) authDidFinish: (BOOL) success forAccount: (AppAccount *) account {
	[self authDidFinish: success forAccount: account canceled: NO];
}

- (void) authDidFinish: (BOOL) success forAccount: (AppAccount *) account canceled: (BOOL) isCanceled {
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
	if (isCanceled == NO) {
		[[NSNotificationCenter defaultCenter] postNotificationName: kAuthorizationNotification object: nil];
	}
}

- (void) logoutFinishedForAccount: (AppAccount *) account {
	if (account == _account) {
		account.sessionID = nil;
		NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
		
		_account = nil;
		[defs removeObjectForKey: kLastUsedAccountKey];
		[defs synchronize];
	}
}

@end
