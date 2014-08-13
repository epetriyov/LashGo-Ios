//
//  ChecksManager.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 11.08.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ChecksManager.h"

#import "Kernel.h"
#import "DataProvider.h"
#import "ViewControllersManager.h"

@interface ChecksManager () {
	Kernel __weak *_kernel;
	DataProvider __weak *_dataProvider;
	ViewControllersManager __weak *_viewControllersManager;
}

@end

@implementation ChecksManager

- (instancetype) initWithKernel: (Kernel *) kernel
				   dataProvider: (DataProvider *) dataProvider
					  vcManager: (ViewControllersManager *) vcManager {
	if (self = [super init]) {
		_kernel = kernel;
		_dataProvider = dataProvider;
		_viewControllersManager = vcManager;
	}
	return self;
}

- (void) openCheckCardViewController {
	[_viewControllersManager openCheckCardViewController];
	[_dataProvider checks];
}

@end
