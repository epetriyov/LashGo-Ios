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
		_imagePickManager = [[ImagePickManager alloc] initWithKernel: self
														   vcManager: viewControllersManager];
		_userManager = [[UserManager alloc] initWithKernel: self
											  dataProvider: _dataProvider
												 vcManager: viewControllersManager];
		
		[TaskbarManager sharedManager].delegate = self;
		
		[[NSNotificationCenter defaultCenter] addObserver: self
												 selector: @selector(socialAuthorizationSuccess)
													 name: kAuthorizationNotification
												   object: nil];
	}
	return self;
}


#pragma mark - Methods

- (void) socialAuthorizationSuccess {
	[self.userManager socialSignIn];
}

- (void) performOnColdWakeActions {
	
}

#pragma mark - DataProviderDelegate implementation

- (void) dataProviderDidRecoverPass: (DataProvider *) dataProvider {
	[self.userManager openLoginViewController];
}

- (void) dataProvider: (DataProvider *) dataProvider didGetChecks: (NSArray *) checks {
	[self.storage updateChecksWith: checks];
	[self.viewControllersManager.checkCardViewController refresh];
}

- (void) dataProvider: (DataProvider *) dataProvider didGetCheckVotePhotos: (NSArray *) votePhotos {
	self.storage.checkVotePhotos = votePhotos;
}

- (void) dataProvider: (DataProvider *) dataProvider didGetUserPhotos: (NSArray *) photos {
	self.viewControllersManager.profileViewController.photos = photos;
}

#pragma mark - TaskbarManagerDelegate implementation

- (void) taskbarManager: (TaskbarManager *) manager didPressTaskbarButtonWithType: (TaskbarButtonType) type {
	switch (type) {
		case TaskbarButtonTypeFollow:
			break;
		case TaskbarButtonTypeMore:
			break;
		case TaskbarButtonTypeNews:
			break;
		case TaskbarButtonTypeProfile:
			break;
		case TaskbarButtonTypeTask:
			break;
		default:
			break;
	}
}

@end
