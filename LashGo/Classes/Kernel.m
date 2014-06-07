//
//  Kernel.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "Kernel.h"

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
		viewControllersManager = [[ViewControllersManager alloc] initWithKernel: self];
	}
	return self;
}

- (void) dealloc {
	[viewControllersManager release];
	
	[super dealloc];
}

#pragma mark - Methods

- (void) performOnColdWakeActions {
	
}

@end
