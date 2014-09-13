//
//  LoginViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 30.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LoginViewController.h"

#import "AuthorizationManager.h"
#import "CryptoUtils.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void) loadView {
	[super loadView];
	
	float offsetY = self.contentFrame.origin.y;
	
	UITextField *emailField = [[UITextField alloc] initWithFrame: CGRectMake(0, offsetY, 320, 40)];
	emailField.backgroundColor = [UIColor grayColor];
	[self.view addSubview: emailField];
	_emailField = emailField;
	
	offsetY += _emailField.frame.size.height + 10;
	
	UITextField *passwordField = [[UITextField alloc] initWithFrame: CGRectMake(0, offsetY, 320, 40)];
	passwordField.backgroundColor = [UIColor grayColor];
	[self.view addSubview: passwordField];
	_passwordField = passwordField;
	
	offsetY += _passwordField.frame.size.height + 10;
	
	UIButton *loginButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	[loginButton setTitle: @"Login" forState: UIControlStateNormal];
	loginButton.frame = CGRectMake(0, offsetY, 320, 40);
	[loginButton addTarget: self action: @selector(login:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: loginButton];
	
	offsetY += loginButton.frame.size.height + 10;
	
	loginButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
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
	
	UILabel *tokenLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY, 320, 120)];
	tokenLabel.numberOfLines = 4;
	tokenLabel.text = [AuthorizationManager sharedManager].account.accessToken;
	[self.view addSubview: tokenLabel];
	_tokenLabel = tokenLabel;
}

- (void) login: (id) sender {
	LGLoginInfo *loginInfo = [[LGLoginInfo alloc] init];
	loginInfo.login = _emailField.text;
	loginInfo.passwordHash = _passwordField.text.md5;
	
	[[AuthorizationManager sharedManager] loginUsingLashGo: loginInfo];
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
