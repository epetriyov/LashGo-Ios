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
#import "DataProvider.h"
#import "Storage.h"

@interface Kernel : NSObject <DataProviderDelegate> {
	ViewControllersManager *viewControllersManager;
}

@property (nonatomic, readonly) UIViewController *rootViewController;

@property (nonatomic, readonly) ChecksManager *checksManager;
@property (nonatomic, readonly) Storage *storage;
@property (nonatomic, readonly) ViewControllersManager *viewControllersManager;

- (void) performOnColdWakeActions;

@end
