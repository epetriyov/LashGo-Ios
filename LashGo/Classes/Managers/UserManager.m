//
//  UserManager.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 13.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "UserManager.h"

#import "Kernel.h"
#import "DataProvider.h"
#import "ViewControllersManager.h"

@interface UserManager () {
	Kernel __weak *_kernel;
	DataProvider __weak *_dataProvider;
	ViewControllersManager __weak *_viewControllersManager;
}

@end

@implementation UserManager

- (instancetype) initWithKernel: (Kernel *) kernel
				   dataProvider: (DataProvider *) dataProvider
					  vcManager: (ViewControllersManager *) vcManager {
	if (self = [super init]) {
		_kernel = kernel;
		_dataProvider = dataProvider;
		_viewControllersManager = vcManager;
	}
	return self;
}

#pragma mark - Methods

- (void) recoverPasswordWithEmail: (NSString *) email {
	LGRecoverInfo *recoverInfo = [[LGRecoverInfo alloc] init];
	recoverInfo.email = email;
	
	[_dataProvider userRecover: recoverInfo];
}

- (void) socialSignIn {
	LGSocialInfo *socialInfo = [[LGSocialInfo alloc] init];
	socialInfo.accessToken = [AuthorizationManager sharedManager].account.accessToken;
	socialInfo.socialName = [AuthorizationManager sharedManager].account.accountSocialName;
	
//	[_dataProvider userSocialSignIn: ]
}

- (void) openLoginViewController {
	[_viewControllersManager openLoginViewController];
}

- (void) openRecoverViewController {
	[_viewControllersManager openViewController:_viewControllersManager.recoverViewController animated: YES];
}

@end
