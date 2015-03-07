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

- (void) getUserProfile {
	[_dataProvider userProfile];
}

- (void) getUsersSearch: (NSString *) searchText {
	[_dataProvider usersSearch: searchText];
}

- (void) getUserPhotosForUser: (LGUser *) user {
	[_viewControllersManager.rootNavigationController addWaitViewControllerOfClass: [ProfileViewController class]];
	[_dataProvider userPhotosFor: user.uid];
}

- (void) stopWaitingUserPhotos {
	[_viewControllersManager.rootNavigationController removeWaitViewControllerOfClass: [ProfileViewController class]];
}

- (void) getSubscribersForUser: (LGUser *) user {
	[_dataProvider userSubscribersFor: user];
}

- (void) getSubscribtionsForUser: (LGUser *) user {
	[_dataProvider userSubscribtionsFor: user];
}

#pragma mark -

- (void) updateUser: (LGUser *) user {
	[_dataProvider userProfileUpdateWith: user];
}

- (void) updateUserAvatar: (UIImage *) image {
	[_viewControllersManager.rootNavigationController addWaitViewControllerOfClass: [ProfileEditViewController class]];
	NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
	[_dataProvider userAvatarUpdateWith: imageData];
}

#pragma mark -

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

- (void) subscribeToUser: (LGUser *) user {
	LGSubscription *subscription = [[LGSubscription alloc] init];
	subscription.user = user;
	subscription.isSubscribed = user.subscription;
	
	LGSubscribe *subscribe = [[LGSubscribe alloc] init];
	subscribe.subscription = subscription;
	[_dataProvider userSubscribeTo: subscribe];
}

- (void) unsubscribeFrom: (LGSubscription *) subscription {
	LGSubscribe *subscribe = [[LGSubscribe alloc] init];
	subscribe.subscription = subscription;
	[_dataProvider userUnsubscribeFrom: subscribe];
}

- (void) unsubscribeFromUser: (LGUser *) user {
	LGSubscription *subscription = [[LGSubscription alloc] init];
	subscription.user = user;
	subscription.isSubscribed = user.subscription;
	
	LGSubscribe *subscribe = [[LGSubscribe alloc] init];
	subscribe.subscription = subscription;
	[_dataProvider userUnsubscribeFrom: subscribe];
}

#pragma mark -

- (void) openEventsViewVontroller {
	[_viewControllersManager openViewController: _viewControllersManager.eventsViewController animated: YES];
	[_dataProvider events];
}

- (void) openNewsViewController {
	[_viewControllersManager openViewController: _viewControllersManager.newsViewController animated: YES];
	[_dataProvider news];
}

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

- (void) openSubscribersWith: (LGUser *) user {
	SubscriptionViewController *vc = _viewControllersManager.subscriptionViewController;
	vc.context = user;
    vc.mode = SubscriptionViewControllerModeUserSubscribers;
	[_viewControllersManager openViewController: vc animated: YES];
}

- (void) openSubscribtionsWith: (LGUser *) user {
	SubscriptionViewController *vc = _viewControllersManager.subscriptionViewController;
	vc.context = user;
    vc.mode = SubscriptionViewControllerModeUserSubscribtions;
	[_viewControllersManager openViewController: vc animated: YES];
}

#pragma mark -

- (void) openEULAViewController {
//	NSData *content = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"EULA"
//																					  ofType: @"html"]];
	LicenseViewController *vc = _viewControllersManager.licenseViewController;
//	vc.content = content;
	vc.contentURLString = @"http://lashgo.com/terms.html";
	[_viewControllersManager.rootNavigationController presentViewController: vc animated: YES completion: nil];
}

- (void) openPrivacyPolicyViewController {
//	NSData *content = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"PrivacyPolicy"
//																					  ofType: @"html"]];
	LicenseViewController *vc = _viewControllersManager.licenseViewController;
//	vc.content = content;
	vc.contentURLString = @"http://lashgo.com/privacy.html";
	[_viewControllersManager.rootNavigationController presentViewController: vc animated: YES completion: nil];
}

@end
