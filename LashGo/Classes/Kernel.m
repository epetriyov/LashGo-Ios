//
//  Kernel.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "Kernel.h"

#import "DataProvider.h"

#import "AlertViewManager.h"
#import "Common.h"

@interface Kernel () <UIActionSheetDelegate> {
	DataProvider *_dataProvider;
}

@end

@implementation Kernel

@synthesize viewControllersManager;
@dynamic rootViewController;

#pragma mark - Properties

- (UIViewController *) rootViewController {
	return viewControllersManager.rootNavigationController;
}

#pragma mark - Overrides

- (id) init {
	if (self = [super init]) {
		_storage = [[Storage alloc] init];
		_dataProvider = [[DataProvider alloc] init];
		_dataProvider.delegate = self;
		
		viewControllersManager = [[ViewControllersManager alloc] initWithKernel: self];
		
		_checksManager = [[ChecksManager alloc] initWithKernel: self
												  dataProvider: _dataProvider
													 vcManager: viewControllersManager];
		_imagePickManager = [[ImagePickManager alloc] initWithKernel: self
														   vcManager: viewControllersManager];
		_userManager = [[UserManager alloc] initWithKernel: self
											  dataProvider: _dataProvider
												 vcManager: viewControllersManager];
		
		[TaskbarManager sharedManager].delegate = self;
		
		[[NSNotificationCenter defaultCenter] addObserver: self
												 selector: @selector(authorizationSuccess)
													 name: kAuthorizationNotification
												   object: nil];
	}
	return self;
}


#pragma mark - Methods

- (void) authorizationSuccess {
	if ([Common isEmptyString: [AuthorizationManager sharedManager].account.sessionID] == NO) {
		[self.checksManager openCheckCardViewController];
	} else {
		[[AlertViewManager sharedManager] showAlertAuthorizationFails];
	}
//	[self.userManager openProfileWelcomeViewController];
	
}

- (void) performOnColdWakeActions {
	if ([AuthorizationManager sharedManager].account != nil) {
		[self.checksManager openCheckCardViewController];
	}
}

- (void) stopWaiting: (UIViewController *) viewController {
	[viewControllersManager.rootNavigationController removeWaitViewControllerOfClass: [viewController class]];
}

#pragma mark - DataProviderDelegate implementation

- (void) dataProviderDidRecoverPass: (DataProvider *) dataProvider {
	[self.userManager openLoginViewController];
}

- (void) dataProvider: (DataProvider *) dataProvider didGetChecks: (NSArray *) checks {
	[self.storage updateChecksWith: checks];
	[self.viewControllersManager.checkCardViewController refresh];
}

- (void) dataProvider: (DataProvider *) dataProvider didGetCheckPhotos: (NSArray *) photos {
	self.storage.checkPhotos = photos;
}

- (void) dataProvider: (DataProvider *) dataProvider didGetCheckVotePhotos: (LGVotePhotosResult *) votePhotos {
	self.storage.checkVotePhotos = votePhotos;
}

- (void) dataProvider: (DataProvider *) dataProvider didGetSubscriptions: (LGSubscriptionsResult *) subscriptions {
	SubscriptionViewController *vc = [viewControllersManager getSubscriptionViewControllerWithContext:
									  subscriptions.context];
	vc.subscriptions = subscriptions.items;
}

- (void) dataProvider: (DataProvider *) dataProvider didPhotoVote: (LGVoteAction *) voteAction {
	for (LGVotePhoto *votePhoto in voteAction.votePhotos) {
		votePhoto.isShown = YES;
		votePhoto.isVoted = votePhoto.photo.uid == voteAction.votedPhotoUID;
	}
	[self.viewControllersManager.voteViewController voteFinished];
}

- (void) dataProvider: (DataProvider *) dataProvider didGetUserPhotos: (NSArray *) photos {
	self.viewControllersManager.profileViewController.photos = photos;
}

- (void) dataProvider: (DataProvider *) dataProvider didGetUserProfile: (LGUser *) user {
	self.storage.lastViewProfileDetail = user;
}

- (void) dataProvider: (DataProvider *) dataProvider didUserSubscribeTo: (LGSubscribe *) subscribe {
	subscribe.subscription.isSubscribed = YES;
}

- (void) dataProvider: (DataProvider *) dataProvider didUserUnsubscribeFrom: (LGSubscribe *) subscribe {
	subscribe.subscription.isSubscribed = NO;
}

#pragma mark - UIActionSheetDelegate implementation

- (void) showMenu {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self
													cancelButtonTitle: @"ImagePickerActionSheetCancelTitle".commonLocalizedString
											   destructiveButtonTitle: nil
													otherButtonTitles: @"MenuActionSheetLogoutTitle".commonLocalizedString, nil];
	[actionSheet showInView: viewControllersManager.rootNavigationController.topViewController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			[[AuthorizationManager sharedManager].account logout];
			[viewControllersManager openStartViewController];
			break;
		default:
			break;
	}
}

#pragma mark - TaskbarManagerDelegate implementation

- (void) taskbarManager: (TaskbarManager *) manager didPressTaskbarButtonWithType: (TaskbarButtonType) type {
	switch (type) {
		case TaskbarButtonTypeFollow:
			break;
		case TaskbarButtonTypeMore:
			[self showMenu];
			break;
		case TaskbarButtonTypeNews:
			break;
		case TaskbarButtonTypeProfile:
			[self.userManager openProfileViewController];
			break;
		case TaskbarButtonTypeTask:
			break;
		default:
			break;
	}
}

@end
