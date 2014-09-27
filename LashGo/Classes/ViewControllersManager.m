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
	
	VoteViewController __weak *_voteViewController;
}

@end

@implementation ViewControllersManager

@synthesize rootNavigationController;
@dynamic isReturnToPreviousAvaliable;
@dynamic recoverViewController, voteViewController;

#pragma mark - Properties

- (BOOL) isReturnToPreviousAvaliable {
	return [rootNavigationController.viewControllers count] > 1;
}

- (VoteViewController *) voteViewController {
	if (_voteViewController == nil) {
		_voteViewController = [self createViewControllerOfClass: [VoteViewController class]];
	}
	return _voteViewController;
}

- (RecoverViewController *) recoverViewController {
	return [self createViewControllerOfClass: [RecoverViewController class]];
}

#pragma mark - Overrides

- (id) initWithKernel: (Kernel *) theKernel {
    if (self = [super init]) {
        kernel = theKernel;
		
		_checkCardViewController =	[self createViewControllerOfClass: [CheckCardViewController class]];
		_checkListViewController =	[self createViewControllerOfClass: [CheckListViewController class]];
		_loginViewController =		[self createViewControllerOfClass: [LoginViewController class]];
		
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
