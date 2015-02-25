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

@interface Kernel () <UIActionSheetDelegate, AlertViewManagerDelegate> {
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
		
		[AlertViewManager sharedManager].delegate = self;
		[TaskbarManager sharedManager].delegate = self;
		
		if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
			[UITextField appearance].tintColor = [UIColor colorWithRed: 1.0 green: 94.0/255.0 blue: 124.0/255.0 alpha: 1.0];
		}
		
		
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
	[UIActivityIndicatorView appearance].color = [UIColor colorWithRed:253.0/255.0 green: 5.0/255.0 blue: 160.0/255.0 alpha: 1.0];
}

- (void) startWaiting: (UIViewController *) viewController {
	[viewControllersManager.rootNavigationController addWaitViewControllerOfClass: [viewController class]];
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
	[self.viewControllersManager.checkListViewController refresh];
}

- (void) dataProvider: (DataProvider *) dataProvider didGetChecksSearch: (NSArray *) checks {
	_storage.searchChecks = checks;
}

- (void) dataProvider: (DataProvider *) dataProvider didGetUsersSearch: (NSArray *) users {
	_storage.searchUsers = users;
}

- (void) dataProvider: (DataProvider *) dataProvider didGetCheckPhotos: (NSArray *) photos {
	self.storage.checkPhotos = photos;
}

- (void) dataProvider: (DataProvider *) dataProvider didGetCheckVotePhotos: (LGVotePhotosResult *) votePhotos {
	self.storage.checkVotePhotos = votePhotos;
}

- (void) dataProvider: (DataProvider *) dataProvider didGetComments: (ContextualArrayResult *) comments {
	CommentsViewController *vc = [viewControllersManager getCommentsViewControllerWithContext: comments.context];
	vc.comments = comments.items;
}

- (void) dataProvider: (DataProvider *) dataProvider didGetVotes: (ContextualArrayResult *) votes {
	SubscriptionViewController *vc = [viewControllersManager getSubscriptionViewControllerWithContext: votes.context];
	vc.subscriptions = votes.items;
}

- (void) dataProvider: (DataProvider *) dataProvider didGetEvents: (NSArray *) events {
	self.storage.events = events;
}

- (void) dataProvider: (DataProvider *) dataProvider didGetNews: (NSArray *) news {
	self.storage.news = news;
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

- (void) dataProvider: (DataProvider *) dataProvider didGetPhotoWithCounters: (LGPhoto *) photo {
    ///!!!:Future optimization required
	if ([self.viewControllersManager.rootNavigationController.topViewController isKindOfClass: [CheckDetailViewController class]] == YES) {
		CheckDetailViewController *vc = (CheckDetailViewController *)self.viewControllersManager.rootNavigationController.topViewController;
		[vc refreshCounters];
	}
}

- (void) dataProvider: (DataProvider *) dataProvider didGetUserPhotos: (NSArray *) photos {
	self.viewControllersManager.profileViewController.photos = photos;
}

- (void) dataProvider: (DataProvider *) dataProvider didGetUserProfile: (LGUser *) user {
	self.storage.lastViewProfileDetail = user;
}

- (void) dataProvider: (DataProvider *) dataProvider didUserProfileUpdate: (LGUser *) user {
	self.storage.lastViewProfileDetail = user;
	if (self.viewControllersManager.rootNavigationController.topViewController ==
		self.viewControllersManager.profileEditViewController) {
		[self.viewControllersManager returnToPreviousViewController];
	}
}

- (void) dataProvider: (DataProvider *) dataProvider didUserSubscribeTo: (LGSubscribe *) subscribe {
	subscribe.subscription.isSubscribed = YES;
	subscribe.subscription.user.subscription = YES;
}

- (void) dataProvider: (DataProvider *) dataProvider didUserUnsubscribeFrom: (LGSubscribe *) subscribe {
	subscribe.subscription.isSubscribed = NO;
	subscribe.subscription.user.subscription = NO;
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

#pragma mark - AlertViewManagerDelegate implementation

- (void) alertViewManagerDidConfirmComplain: (AlertViewManager *) manager withContext: (id) context {
	if ([context isKindOfClass: [LGPhoto class]] == YES) {
		[_dataProvider photoComplainFor: context];
	}
}

#pragma mark - TaskbarManagerDelegate implementation

- (void) taskbarManager: (TaskbarManager *) manager didPressTaskbarButtonWithType: (TaskbarButtonType) type {
	switch (type) {
		case TaskbarButtonTypeFollow:
			[self.userManager openEventsViewVontroller];
			break;
		case TaskbarButtonTypeMore:
			[self showMenu];
			break;
		case TaskbarButtonTypeNews:
			[self.userManager openNewsViewController];
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
