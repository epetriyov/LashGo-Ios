//
//  RootNavigationController.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 23.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "RootNavigationController.h"
#import "RootNavigationControllerItemProtocol.h"

@interface RootNavigationController ()

@end

@implementation RootNavigationController

//Not need while we have portrait only
//- (NSUInteger) supportedInterfaceOrientations {
//	if ([self.topViewController respondsToSelector: @selector(supportedInterfaceOrientations)] == YES) {
//		return [self.topViewController supportedInterfaceOrientations];
//	} else {
//		return 0;
//	}
//}

- (void) loadView {
	[super loadView];
	
	if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] == YES) {
		self.interactivePopGestureRecognizer.delegate = self;
		self.delegate = self;
	}
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	//To fix crash when we call push and then quickly swipe back (navigation stack will be corrupted)
	if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] == YES) {
		self.interactivePopGestureRecognizer.enabled = NO;
	}
	
	[super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate {
	// Enable the gesture again once the new controller is shown
	if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)] == YES) {
		if ([viewController conformsToProtocol: @protocol(RootNavigationControllerItemProtocol)] == YES &&
			((id<RootNavigationControllerItemProtocol>) viewController).canGoBack == YES) {
			self.interactivePopGestureRecognizer.enabled = YES;
		} else {
			self.interactivePopGestureRecognizer.enabled = NO;
		}
	}
}

@end
