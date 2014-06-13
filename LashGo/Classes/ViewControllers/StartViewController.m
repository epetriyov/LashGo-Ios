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
	
	float offsetY = self.contentFrame.origin.y;
	
	UIButton *loginButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	[loginButton setTitle: @"Login with Facebook" forState: UIControlStateNormal];
	loginButton.frame = CGRectMake(0, offsetY, 320, 40);
	[loginButton addTarget: self action: @selector(loginWithFacebook:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: loginButton];
	
	offsetY += loginButton.frame.size.height + 10;
	
	loginButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	[loginButton setTitle: @"Login with Twitter" forState: UIControlStateNormal];
	loginButton.frame = CGRectMake(0, offsetY, 320, 40);
	[loginButton addTarget: self action: @selector(loginWithTwitter:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: loginButton];
}

- (void) loginWithFacebook: (id) sender {
	[[AuthorizationManager sharedManager] loginUsingFacebook];
}

- (void) loginWithTwitter: (id) sender {
	[[AuthorizationManager sharedManager] loginUsingTwitter];
}

@end
