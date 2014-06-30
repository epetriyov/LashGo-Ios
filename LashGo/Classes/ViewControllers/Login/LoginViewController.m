//
//  LoginViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 30.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LoginViewController.h"

#import "AuthorizationManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void) loadView {
	[super loadView];
	
	float offsetY = self.contentFrame.origin.y;
	
	_emailField = [[UITextField alloc] initWithFrame: CGRectMake(0, offsetY, 320, 40)];
	[self.view addSubview: _emailField];
	
	offsetY += _emailField.frame.size.height + 10;
	
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
	
	offsetY += loginButton.frame.size.height + 10;
	
	loginButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	[loginButton setTitle: @"Login with Vkontakte" forState: UIControlStateNormal];
	loginButton.frame = CGRectMake(0, offsetY, 320, 40);
	[loginButton addTarget: self action: @selector(loginWithVkontakte:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: loginButton];
	
	offsetY += loginButton.frame.size.height + 10;
	
	_tokenLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY, 320, 120)];
	_tokenLabel.text = [AuthorizationManager sharedManager].account.accessToken;
	[self.view addSubview: _tokenLabel];
}

- (void) loginWithFacebook: (id) sender {
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(authorizationSuccess)
												 name: kAuthorizationNotification
											   object: nil];
	[[AuthorizationManager sharedManager] loginUsingFacebook];
}

- (void) loginWithTwitter: (id) sender {
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(authorizationSuccess)
												 name: kAuthorizationNotification
											   object: nil];
	[[AuthorizationManager sharedManager] loginUsingTwitterFromView: self.view];
}

- (void) loginWithVkontakte: (id) sender {
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(authorizationSuccess)
												 name: kAuthorizationNotification
											   object: nil];
	[[AuthorizationManager sharedManager] loginUsingVkontakte];
}

- (void) authorizationSuccess {
	[[NSNotificationCenter defaultCenter] removeObserver: self name: kAuthorizationNotification object: nil];
	_tokenLabel.text = [AuthorizationManager sharedManager].account.accessToken;
}

@end
