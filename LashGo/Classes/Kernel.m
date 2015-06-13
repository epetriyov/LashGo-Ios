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
#import "FontFactory.h"
#import "UIColor+CustomColors.h"

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
		_pushNotificationManager = [[PushNotificationManager alloc] initWithDataProvider: _dataProvider];
		_userManager = [[UserManager alloc] initWithKernel: self
											  dataProvider: _dataProvider
												 vcManager: viewControllersManager];
		
		[AlertViewManager sharedManager].delegate = self;
		[TaskbarManager sharedManager].delegate = self;
		
		UIColor *appTintColor = [UIColor colorWithAppColorType: AppColorTypeTint];
		
		if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
			[UINavigationBar appearance].tintColor = appTintColor;
			[UINavigationBar appearance].titleTextAttributes = @{UITextAttributeFont : [FontFactory fontWithType: FontTypeTitleBarTitle],
																 UITextAttributeTextColor : [FontFactory fontColorForType: FontTypeTitleBarTitle]};
		} else {
			[UINavigationBar appearance].barTintColor = appTintColor;
			[UINavigationBar appearance].tintColor = [FontFactory fontColorForType: FontTypeTitleBarButtons];
			[UINavigationBar appearance].titleTextAttributes = @{NSFontAttributeName : [FontFactory fontWithType: FontTypeTitleBarTitle],
																 NSForegroundColorAttributeName : [FontFactory fontColorForType: FontTypeTitleBarTitle]};
			[UITextField appearance].tintColor = [UIColor colorWithAppColorType: AppColorTypeSecondaryTint];
			
#ifdef __IPHONE_8_0
			if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
				[UINavigationBar appearance].translucent = NO;
			}
#endif
		}
		[UIActivityIndicatorView appearance].color = [UIColor colorWithAppColorType: AppColorTypeSecondaryTint];
		
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
	if (self.pushNotificationManager.lastPayload != nil) {
		[self.checksManager openCheckCardViewControllerWithFetchForCheckUID: self.pushNotificationManager.lastPayload.checkUID];
	} else if ([AuthorizationManager sharedManager].account != nil) {
		[self.checksManager openCheckCardViewController];
	}
}

- (void) startWaiting: (UIViewController *) viewController {
	[viewControllersManager.rootNavigationController addWaitViewControllerOfClass: [viewController class]];
}

- (void) stopWaiting: (UIViewController *) viewController {
	[viewControllersManager.rootNavigationController removeWaitViewControllerOfClass: [viewController class]];
}

- (BOOL) isUnauthorizedMode {
	return [Common isEmptyString: [AuthorizationManager sharedManager].account.sessionID];
}

- (BOOL) isUnauthorizedActionAllowed {
	if ([self isUnauthorizedMode] == YES) {
		[viewControllersManager openLoginViewController];
		return NO;
	}
	return YES;
}

#pragma mark - DataProviderDelegate implementation

- (void) dataProviderDidRecoverPass: (DataProvider *) dataProvider {
	[self.userManager openLoginViewController];
}

- (void) dataProvider: (DataProvider *) dataProvider didGetChecks: (ContextualArrayResult *) checks {
	_storage.checks = checks.items;
	
	if ([checks.context isKindOfClass: [NSNumber class]] == YES) {
		[self.checksManager openCheckCardViewControllerForCheckUID: [checks.context longLongValue]];
	}
}

- (void) dataProvider: (DataProvider *) dataProvider didGetChecksActions: (NSArray *) checksActions {
//	_storage.checksActions = checksActions;
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

- (void) dataProviderDidUserAvatarUpdate: (DataProvider *) dataProvider {
	[self.viewControllersManager.rootNavigationController removeWaitViewControllerOfClass: [ProfileEditViewController class]];
	[self.userManager getUserProfile];
}

- (void) dataProviderDidFailUserAvatarUpdate: (DataProvider *) dataProvider {
	[self.viewControllersManager.rootNavigationController removeWaitViewControllerOfClass: [ProfileEditViewController class]];
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
	NSString *actionBtnTitle;
	if ([self isUnauthorizedMode] == YES) {
		actionBtnTitle = @"LoginViewControllerTitle".commonLocalizedString;
	} else {
		actionBtnTitle = @"MenuActionSheetLogoutTitle".commonLocalizedString;
	}
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self
													cancelButtonTitle: @"ImagePickerActionSheetCancelTitle".commonLocalizedString
											   destructiveButtonTitle: nil
													otherButtonTitles: actionBtnTitle, nil];
	[actionSheet showInView: viewControllersManager.rootNavigationController.topViewController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			if ([self isUnauthorizedMode] == YES) {
				[viewControllersManager openLoginViewController];
			} else {
				[[AuthorizationManager sharedManager].account logout];
				[viewControllersManager openStartViewController];
				_storage.checks = nil;
//				[_storage updateChecksWith: @[]];
			}
			break;
		default:
			break;
	}
}

#pragma mark - AlertViewManagerDelegate implementation

- (void) alertViewManagerDidConfirmCheckActivityView: (AlertViewManager *) manager withContext: (id) context {
	if ([context isKindOfClass: [PushNotificationPayload class]] == YES) {
		[self.checksManager openCheckCardViewControllerWithFetchForCheckUID: ((PushNotificationPayload *) context).checkUID];
	}
}

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
			[self.checksManager openCheckListViewController];
			break;
		default:
			break;
	}
}

@end
