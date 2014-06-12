//
//  StartViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 07.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "StartViewController.h"
#import "AuthorizationManager.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void) loadView {
	[super loadView];
	
	UIButton *loginButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	[loginButton setTitle: @"Login with Facebook" forState: UIControlStateNormal];
	loginButton.frame = CGRectMake(self.contentFrame.origin.y, 0, 320, 20);
	[loginButton addTarget: self action: @selector(loginWithFacebook:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: loginButton];
}

- (void) loginWithFacebook: (id) sender {
	[[AuthorizationManager sharedManager] loginUsingFacebook];
}

@end
