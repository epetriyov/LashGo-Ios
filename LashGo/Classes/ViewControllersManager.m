//
//  ViewControllersManager.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ViewControllersManager.h"

@implementation ViewControllersManager

@synthesize rootNavigationController;
@dynamic isReturnToPreviousAvaliable;

#pragma mark - Properties

- (BOOL) isReturnToPreviousAvaliable {
	return [rootNavigationController.viewControllers count] > 1;
}

#pragma mark - Overrides

- (id) initWithKernel: (Kernel *) theKernel {
    if (self = [super init]) {
        kernel = theKernel;
		
		_loginViewController = [self createViewControllerOfClass: [LoginViewController class]];
		
		startViewController = [self createViewControllerOfClass: [StartViewController class]];
		
		rootNavigationController = [[RootNavigationController alloc] initWithRootViewController: startViewController];
		rootNavigationController.navigationBarHidden = YES;
		rootNavigationController.view.backgroundColor = [UIColor whiteColor];
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

- (void) openLoginViewController {
	[self openViewController: _loginViewController animated: YES];
}

@end
