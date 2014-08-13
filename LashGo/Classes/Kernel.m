//
//  Kernel.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "Kernel.h"

#import "DataProvider.h"

@interface Kernel () {
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
	}
	return self;
}


#pragma mark - Methods

- (void) performOnColdWakeActions {
	
}

#pragma mark - DataProviderDelegate implementation

- (void) dataProvider: (DataProvider *) dataProvider didGetChecks: (NSArray *) checks {
	[self.storage updateChecksWith: checks];
	[self.viewControllersManager.checkCardViewController refresh];
}

@end
