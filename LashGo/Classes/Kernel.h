//
//  Kernel.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ViewControllersManager.h"
#import "AuthorizationManager.h"

#import "ChecksManager.h"
#import "ImagePickManager.h"
#import "UserManager.h"

#import "DataProvider.h"
#import "Storage.h"
#import "TaskbarManager.h"

@interface Kernel : NSObject <DataProviderDelegate, TaskbarManagerDelegate> {
	ViewControllersManager *viewControllersManager;
}

@property (nonatomic, readonly) UIViewController *rootViewController;

@property (nonatomic, readonly) ChecksManager *checksManager;
@property (nonatomic, readonly)	ImagePickManager *imagePickManager;
@property (nonatomic, readonly) UserManager *userManager;

@property (nonatomic, readonly) Storage *storage;
@property (nonatomic, readonly) ViewControllersManager *viewControllersManager;

- (void) performOnColdWakeActions;

- (void) stopWaiting: (UIViewController *) viewController;

@end
