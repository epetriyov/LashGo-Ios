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

@implementation AuthorizationManager

+ (instancetype) sharedManager {
	SHARED_INSTANCE_WITH_BLOCK(^{
		return [[self alloc] init];
	})
}

#pragma mark - Methods

- (void) loginUsingFacebook {
	if (_account == nil) {
		_account = [[FacebookAppAccount alloc] init];
	}
	[(FacebookAppAccount*)_account login];
}

@end
