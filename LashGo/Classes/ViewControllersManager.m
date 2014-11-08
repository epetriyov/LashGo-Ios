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
	
	CheckDetailViewController __weak *_checkDetailViewController;
	VoteViewController __weak *_voteViewController;
	
	ProfileEditViewController __weak *_profileEditViewController;
	ProfileWelcomeViewController __weak *_profileWelcomeViewController;
	ProfileViewController __weak *_profileViewController;
}

@end

@implementation ViewControllersManager

@synthesize rootNavigationController;
@dynamic isReturnToPreviousAvaliable;
@dynamic recoverViewController, checkDetailViewController, voteViewController;
@dynamic profileEditViewController, profileWelcomeViewController, profileViewController;

#pragma mark - Properties

- (BOOL) isReturnToPreviousAvaliable {
	return [rootNavigationController.viewControllers count] > 1;
}

- (CheckDetailViewController *) checkDetailViewController {
	CheckDetailViewController *vc = _checkDetailViewController;
	if (vc == nil) {
		vc = [self createViewControllerOfClass: [CheckDetailViewController class]];
		_checkDetailViewController = vc;
	}
	return vc;
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

#pragma mark - Overrides

- (id) initWithKernel: (Kernel *) theKernel {
    if (self = [super init]) {
        kernel = theKernel;
		
		_checkCardViewController =	[self createViewControllerOfClass: [CheckCardViewController class]];
		_checkListViewController =	[self createViewControllerOfClass: [CheckListViewController class]];
		_loginViewController =		[self createViewControllerOfClass: [LoginViewController class]];
		
		_checkPhotosViewController = [self createViewControllerOfClass: [CheckPhotosViewController class]];
		
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
