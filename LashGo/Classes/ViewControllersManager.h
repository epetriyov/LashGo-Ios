//
//  ViewControllersManager.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "RootNavigationController.h"

#import "CheckCardViewController.h"
#import "CheckListViewController.h"
#import "CheckActionCardViewController.h"
#import "CheckActionListViewController.h"
#import "CheckActionWinnerViewController.h"

#import "CheckDetailViewController.h"
#import "CheckPhotosViewController.h"
#import "VoteViewController.h"

#import "EventsViewController.h"
#import "NewsViewController.h"

#import "LoginViewController.h"
#import "RecoverViewController.h"

#import "LicenseViewController.h"

#import "SearchViewController.h"
#import "StartViewController.h"

#import "ProfileEditViewController.h"
#import "ProfileWelcomeViewController.h"
#import "ProfileViewController.h"

#import "CommentsViewController.h"
#import "SubscriptionViewController.h"

@class Kernel;

@interface ViewControllersManager : NSObject {
	Kernel *kernel;
	
    RootNavigationController *rootNavigationController;
	
	CheckCardViewController *_checkCardViewController;
	
	LoginViewController *_loginViewController;
	
	StartViewController *startViewController;
}

@property (nonatomic, readonly) BOOL isReturnToPreviousAvaliable;
@property (nonatomic, readonly) RootNavigationController *rootNavigationController;

@property (nonatomic, readonly) CheckCardViewController *checkCardViewController;
@property (nonatomic, readonly) CheckListViewController *checkListViewController;
@property (nonatomic, readonly) CheckActionCardViewController *checkActionCardViewController;
@property (nonatomic, readonly) CheckActionListViewController *checkActionListViewController;
@property (nonatomic, readonly) CheckActionWinnerViewController *checkActionWinnerViewController;

@property (nonatomic, readonly) CheckDetailViewController *checkDetailViewController;
@property (nonatomic, readonly) CheckPhotosViewController *checkPhotosViewController;
@property (nonatomic, readonly) VoteViewController *voteViewController;

@property (nonatomic, readonly) EventsViewController *eventsViewController;
@property (nonatomic, readonly) NewsViewController *newsViewController;

@property (nonatomic, readonly) RecoverViewController *recoverViewController;

@property (nonatomic, readonly) LicenseViewController *licenseViewController;

@property (nonatomic, readonly) ProfileEditViewController *profileEditViewController;
@property (nonatomic, readonly) ProfileWelcomeViewController *profileWelcomeViewController;
@property (nonatomic, readonly) ProfileViewController *profileViewController;

@property (nonatomic, readonly) CommentsViewController *commentsViewController;
@property (nonatomic, readonly) SubscriptionViewController *subscriptionViewController;

- (id) initWithKernel: (Kernel *) theKernel;

- (void) openViewController: (UIViewController *) viewController animated: (BOOL) animated;
- (void) openViewControllerAboveFirst: (UIViewController *) viewController animated: (BOOL) animated;
- (void) openViewControllerBelowFirst: (UIViewController *) viewController;
- (void) returnToPreviousViewController;

- (CommentsViewController *) getCommentsViewControllerWithContext: (id) context;
- (SubscriptionViewController *) getSubscriptionViewControllerWithContext: (id) context;

- (void) openStartViewController;

- (void) openCheckCardViewController;
- (void) openCheckListViewController;
- (void) openLoginViewController;
- (void) openSearchViewController;

@end
