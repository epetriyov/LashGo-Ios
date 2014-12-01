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

- (void) getUserPhotosForUser: (LGUser *) user {
	[_viewControllersManager.rootNavigationController addWaitViewControllerOfClass: [ProfileViewController class]];
	[_dataProvider userPhotosFor: user.uid];
}

- (void) stopWaitingUserPhotos {
	[_viewControllersManager.rootNavigationController removeWaitViewControllerOfClass: [ProfileViewController class]];
}

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

#pragma mark -

- (void) subscribeTo: (LGSubscription *) subscription {
	LGSubscribe *subscribe = [[LGSubscribe alloc] init];
	subscribe.subscription = subscription;
	[_dataProvider userSubscribeTo: subscribe];
}

- (void) unsubscribeFrom: (LGSubscription *) subscription {
	
}

#pragma mark -

- (void) openLoginViewController {
	[_viewControllersManager openLoginViewController];
}

- (void) openRecoverViewController {
	[_viewControllersManager openViewController:_viewControllersManager.recoverViewController animated: YES];
}

- (void) openProfileEditViewControllerWith: (LGUser *) user {
	ProfileEditViewController *vc = _viewControllersManager.profileEditViewController;
	vc.user = user;
	[_viewControllersManager openViewController: vc animated: YES];
}

- (void) openProfileWelcomeViewController {
	ProfileWelcomeViewController *vc = _viewControllersManager.profileWelcomeViewController;
	vc.user = [AuthorizationManager sharedManager].account.userInfo;
	[_viewControllersManager openViewControllerAboveFirst: vc animated: YES];
}

- (void) openProfileViewController {
	[self openProfileViewControllerWith: [AuthorizationManager sharedManager].account.userInfo];
}

- (void) openProfileViewControllerWith: (LGUser *) user {
	ProfileViewController *vc = _viewControllersManager.profileViewController;
	if (vc.user != user) {
		vc.photos = nil;
	}
	vc.user = user;
	[_viewControllersManager openViewController: vc animated: YES];
	[_dataProvider userProfileFor: user.uid];
}

@end
