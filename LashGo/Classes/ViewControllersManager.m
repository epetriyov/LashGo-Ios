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
		
		startViewController = [self createViewControllerOfClass: [StartViewController class]];
		
		rootNavigationController = [[RootNavigationController alloc] initWithRootViewController: startViewController];
		rootNavigationController.navigationBarHidden = YES;
		rootNavigationController.view.backgroundColor = [UIColor whiteColor];
    }
	return self;
}


- (id) createViewControllerOfClass: (Class) ViewControllerClass {
	UIViewController *viewController;
	
	if ([ViewControllerClass instancesRespondToSelector: @selector(initWithKernel:)] == YES) {
		viewController = [[ViewControllerClass alloc] initWithKernel: kernel];
	} else {
		viewController = [[ViewControllerClass alloc] init];
	}
	
	return viewController;
}

- (void) returnToPreviousViewController {
	[rootNavigationController popViewControllerAnimated: YES];
}

@end
