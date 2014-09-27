//
//  ViewControllersManager.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "RootNavigationController.h"

#import "CheckCardViewController.h"
#import "CheckListViewController.h"

#import "VoteViewController.h"

#import "LoginViewController.h"
#import "RecoverViewController.h"

#import "SearchViewController.h"
#import "StartViewController.h"

@class Kernel;

@interface ViewControllersManager : NSObject {
	Kernel *kernel;
	
    RootNavigationController *rootNavigationController;
	
	CheckCardViewController *_checkCardViewController;
	
	LoginViewController *_loginViewController;
	
	StartViewController *startViewController;
}

@property (nonatomic, readonly) BOOL isReturnToPreviousAvaliable;
@property (nonatomic, readonly) RootNavigationController *rootNavigationController;

@property (nonatomic, readonly) CheckCardViewController *checkCardViewController;
@property (nonatomic, readonly) CheckListViewController *checkListViewController;

@property (nonatomic, readonly) VoteViewController *voteViewController;

@property (nonatomic, readonly) RecoverViewController *recoverViewController;

- (id) initWithKernel: (Kernel *) theKernel;

- (void) openViewController: (UIViewController *) viewController animated: (BOOL) animated;
- (void) returnToPreviousViewController;

- (void) openCheckCardViewController;
- (void) openCheckListViewController;
- (void) openLoginViewController;
- (void) openSearchViewController;

@end
