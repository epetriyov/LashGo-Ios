//
//  RootNavigationController.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 23.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "RootNavigationController.h"
#import "RootNavigationControllerItemProtocol.h"

@interface RootNavigationController () {
	NSMutableSet *_waitingViewControllers;
}

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

- (id) initWithRootViewController:(UIViewController *)rootViewController {
	if (self = [super initWithRootViewController: rootViewController]) {
		_waitingViewControllers = [[NSMutableSet alloc] initWithCapacity: 1];
	}
	return self;
}

- (void) loadView {
	[super loadView];
	
	if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] == YES) {
		self.interactivePopGestureRecognizer.delegate = self;
	}
	self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	//To fix crash when we call push and then quickly swipe back (navigation stack will be corrupted)
	if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] == YES) {
		self.interactivePopGestureRecognizer.enabled = NO;
	}
	
	[super pushViewController:viewController animated:animated];
}

- (void) addWaitViewControllerOfClass: (Class) vcClass {
	NSParameterAssert([vcClass conformsToProtocol: @protocol(RootNavigationControllerItemProtocol)]);
	//this way no matter about destruction on disappearing
	for (UIViewController *viewController in self.viewControllers) {
		if ([viewController isMemberOfClass: vcClass] == YES) {
			((id<RootNavigationControllerItemProtocol>) viewController).waitViewHidden = NO;
		}
	}
	[_waitingViewControllers addObject: NSStringFromClass(vcClass)];
}

- (void) removeWaitViewControllerOfClass: (Class) vcClass {
	NSParameterAssert([vcClass conformsToProtocol: @protocol(RootNavigationControllerItemProtocol)]);
	[_waitingViewControllers removeObject: NSStringFromClass(vcClass)];
	for (UIViewController *viewController in self.viewControllers) {
		if ([viewController isMemberOfClass: vcClass] == YES) {
			((id<RootNavigationControllerItemProtocol>) viewController).waitViewHidden = YES;
		}
	}
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate {
	if ([viewController conformsToProtocol: @protocol(RootNavigationControllerItemProtocol)] == YES) {
		// Enable the gesture again once the new controller is shown
		if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)] == YES &&
			((id<RootNavigationControllerItemProtocol>) viewController).canGoBack == YES) {
			self.interactivePopGestureRecognizer.enabled = YES;
		} else {
			self.interactivePopGestureRecognizer.enabled = NO;
		}
		if ([_waitingViewControllers containsObject: NSStringFromClass([viewController class])] == YES) {
			((id<RootNavigationControllerItemProtocol>) viewController).waitViewHidden = NO;
		} else {
			((id<RootNavigationControllerItemProtocol>) viewController).waitViewHidden = YES;
		}
	}
}

@end
