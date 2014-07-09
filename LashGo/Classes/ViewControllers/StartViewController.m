//
//  StartViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 07.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "StartViewController.h"

#import "AuthorizationManager.h"
#import "Common.h"
#import "Kernel.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void) loadView {
	[super loadView];
	
	float offsetY = self.view.frame.origin.y;
	
	UIButton *startButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	[startButton setTitle: @"StartViewControllerStartButtonTitle".commonLocalizedString
				 forState: UIControlStateNormal];
	startButton.frame = CGRectMake(0, offsetY, 320, 40);
	[startButton addTarget: self action: @selector(startAction:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: startButton];
	
	offsetY += startButton.frame.size.height + 10;
	
	UIButton *loginButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	[loginButton setTitle: @"StartViewControllerLoginButtonTitle".commonLocalizedString
				 forState: UIControlStateNormal];
	loginButton.frame = CGRectMake(0, offsetY, 320, 40);
	[loginButton addTarget: self action: @selector(loginAction:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: loginButton];
	
	offsetY += startButton.frame.size.height + 10;
	
	_tokenLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY, 320, 120)];
	_tokenLabel.text = [AuthorizationManager sharedManager].account.accessToken;
	[self.view addSubview: _tokenLabel];
}

#pragma mark - Actions

- (void) startAction: (id) sender {
	[kernel.viewControllersManager openCheckCardViewController];
}

- (void) loginAction: (id) sender {
	[kernel.viewControllersManager openLoginViewController];
}

- (void) authorizationSuccess {
	[[NSNotificationCenter defaultCenter] removeObserver: self name: kAuthorizationNotification object: nil];
	_tokenLabel.text = [AuthorizationManager sharedManager].account.accessToken;
}

@end
