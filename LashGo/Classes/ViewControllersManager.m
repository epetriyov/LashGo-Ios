//
//  ViewControllersManager.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ViewControllersManager.h"

@interface ViewControllersManager () {
	SearchViewController *_searchViewController;
	
	CheckActionListViewController __weak *_checkActionListViewController;
	
	CheckDetailViewController __weak *_checkDetailViewController;
	VoteViewController __weak *_voteViewController;
	
	LicenseViewController __weak *_licenseViewController;
	
	ProfileEditViewController __weak *_profileEditViewController;
	ProfileWelcomeViewController __weak *_profileWelcomeViewController;
	ProfileViewController __weak *_profileViewController;
}

@end

@implementation ViewControllersManager

@synthesize rootNavigationController;
@dynamic isReturnToPreviousAvaliable;
@dynamic checkActionListViewController;
@dynamic recoverViewController, checkDetailViewController, voteViewController;
@dynamic licenseViewController;
@dynamic profileEditViewController, profileWelcomeViewController, profileViewController;
@dynamic subscriptionViewController;

#pragma mark - Properties

- (BOOL) isReturnToPreviousAvaliable {
	return [rootNavigationController.viewControllers count] > 1;
}

- (CheckActionListViewController *) checkActionListViewController {
	CheckActionListViewController *vc = _checkActionListViewController;
	if (vc == nil) {
		vc = [self createViewControllerOfClass: [CheckActionListViewController class]];
		_checkActionListViewController = vc;
	}
	return vc;
}

- (CheckDetailViewController *) checkDetailViewController {
//	CheckDetailViewController *vc = _checkDetailViewController;
//	if (vc == nil) {
//		vc = [self createViewControllerOfClass: [CheckDetailViewController class]];
//		_checkDetailViewController = vc;
//	}
//	return vc;
	return [self createViewControllerOfClass: [CheckDetailViewController class]];
}

- (VoteViewController *) voteViewController {
	VoteViewController *vc = _voteViewController;
	if (vc == nil) {
		vc = [self createViewControllerOfClass: [VoteViewController class]];
		_voteViewController = vc;
	}
	return vc;
}

- (RecoverViewController *) recoverViewController {
	return [self createViewControllerOfClass: [RecoverViewController class]];
}

- (LicenseViewController *) licenseViewController {
	LicenseViewController *vc = _licenseViewController;
	if (vc == nil) {
		vc = [self createViewControllerOfClass: [LicenseViewController class]];
		_licenseViewController = vc;
	}
	return vc;
}

- (ProfileEditViewController *) profileEditViewController {
	ProfileEditViewController *vc = _profileEditViewController;
	if (vc == nil) {
		vc = [self createViewControllerOfClass: [ProfileEditViewController class]];
		_profileEditViewController = vc;
	}
	return vc;
}

- (ProfileWelcomeViewController *) profileWelcomeViewController {
	ProfileWelcomeViewController *vc = _profileWelcomeViewController;
	if (vc == nil) {
		vc = [self createViewControllerOfClass: [ProfileWelcomeViewController class]];
		_profileWelcomeViewController = vc;
	}
	return vc;
}

- (ProfileViewController *) profileViewController {
	ProfileViewController *vc = _profileViewController;
	if (vc == nil) {
		vc = [self createViewControllerOfClass: [ProfileViewController class]];
		_profileViewController = vc;
	}
	return vc;
}

- (CommentsViewController *) commentsViewController {
	return [self createViewControllerOfClass: [CommentsViewController class]];
}

- (SubscriptionViewController *) subscriptionViewController {
	return [self createViewControllerOfClass: [SubscriptionViewController class]];
}

#pragma mark - Overrides

- (id) initWithKernel: (Kernel *) theKernel {
    if (self = [super init]) {
        kernel = theKernel;
		
		_checkCardViewController =	[self createViewControllerOfClass: [CheckCardViewController class]];
		_checkListViewController =	[self createViewControllerOfClass: [CheckListViewController class]];
		_loginViewController =		[self createViewControllerOfClass: [LoginViewController class]];
		
		_checkPhotosViewController = [self createViewControllerOfClass: [CheckPhotosViewController class]];
		
		_eventsViewController =		[self createViewControllerOfClass: [EventsViewController class]];
		_newsViewController =		[self createViewControllerOfClass: [NewsViewController class]];
		
		_searchViewController =		[self createViewControllerOfClass: [SearchViewController class]];
		
		startViewController = [self createViewControllerOfClass: [StartViewController class]];
		
		rootNavigationController = [[RootNavigationController alloc] initWithRootViewController: startViewController];
		rootNavigationController.navigationBarHidden = YES;
		rootNavigationController.view.backgroundColor = [UIColor blackColor];
    }
	return self;
}

#pragma mark - Common

- (id) createViewControllerOfClass: (Class) ViewControllerClass {
	UIViewController *viewController;
	
	if ([ViewControllerClass instancesRespondToSelector: @selector(initWithKernel:)] == YES) {
		viewController = [[ViewControllerClass alloc] initWithKernel: kernel];
	} else {
		viewController = [[ViewControllerClass alloc] init];
	}
	
	return viewController;
}

- (void) openViewController: (UIViewController *) viewController animated: (BOOL) animated {
	if (rootNavigationController.topViewController != viewController) {
		if ([rootNavigationController.viewControllers indexOfObject: viewController] == NSNotFound) {
			[rootNavigationController pushViewController: viewController animated: animated];
		} else {
			[rootNavigationController popToViewController: viewController animated: animated];
		}
	}
}

- (void) openViewControllerAndMakeItFirst: (UIViewController *) viewController animated: (BOOL) animated {
	[rootNavigationController setViewControllers: @[viewController] animated: animated];
}

- (void) openViewControllerAboveFirst: (UIViewController *) viewController animated: (BOOL) animated {
	[rootNavigationController setViewControllers: @[_checkCardViewController, viewController] animated: YES];
}

#pragma mark - Methods

- (void) returnToPreviousViewController {
	[rootNavigationController popViewControllerAnimated: YES];
}

#pragma mark -

- (CommentsViewController *) getCommentsViewControllerWithContext: (id) context {
	CommentsViewController *result = nil;
	for (id item in self.rootNavigationController.viewControllers) {
		if ([item isKindOfClass: [CommentsViewController class]] == YES &&
			((CommentsViewController *)item).photo == context) {
			result = item;
			break;
		}
	}
	return result;
}

- (SubscriptionViewController *) getSubscriptionViewControllerWithContext: (id) context {
	SubscriptionViewController *result = nil;
	for (id item in self.rootNavigationController.viewControllers) {
		if ([item isKindOfClass: [SubscriptionViewController class]] == YES &&
			((SubscriptionViewController *)item).context == context) {
			result = item;
			break;
		}
	}
	return result;
}

#pragma mark -

- (void) openStartViewController {
	if ([self.rootNavigationController.topViewController isKindOfClass: [StartViewController class]] == YES) {
		return;
	}
	
	//Open as it always was root
	NSMutableArray *vcStack = [[NSMutableArray alloc] initWithArray: rootNavigationController.viewControllers
														  copyItems: NO];
	[vcStack insertObject: startViewController atIndex: 0];
	[self.rootNavigationController setViewControllers: vcStack animated: NO];
	
	[self openViewController: startViewController animated: YES];
}

- (void) openCheckCardViewController {
	[self openViewControllerAndMakeItFirst: _checkCardViewController animated: YES];
}

- (void) openCheckListViewController {
	[self openViewControllerAndMakeItFirst: _checkListViewController animated: YES];
}

- (void) openLoginViewController {
	[self openViewController: _loginViewController animated: YES];
}

- (void) openSearchViewController {
	[self openViewController: _searchViewController animated: YES];
}

@end
