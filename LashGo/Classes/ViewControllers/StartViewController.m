//
//  StartViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 07.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "StartViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface StartViewController ()

@end

@implementation StartViewController

- (void) loadView {
	[super loadView];
	
	FBLoginView *loginView = [[FBLoginView alloc] init];
	// Align the button in the center horizontally
	loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 5);
	[self.view addSubview:loginView];
}

@end
