//
//  ViewControllersManager.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "RootNavigationController.h"

#import "TitleBarViewController.h"

@class Kernel;

@interface ViewControllersManager : NSObject {
	Kernel *kernel;
	
	///Retains VC's for easy memory management
	NSMutableArray *viewControllersStorage;
    
    RootNavigationController *rootNavigationController;
	
	TitleBarViewController *startViewController;
}

@property (nonatomic, readonly) BOOL isReturnToPreviousAvaliable;
@property (nonatomic, readonly) RootNavigationController *rootNavigationController;

- (id) initWithKernel: (Kernel *) theKernel;

- (void) returnToPreviousViewController;

@end
