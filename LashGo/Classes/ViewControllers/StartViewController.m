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
	
	float buttonsWidth = self.view.frame.size.width / 2;
	float buttonsHeight = 60;
	float offsetY = self.view.frame.size.height - buttonsHeight;
	
	UIButton *startButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	[startButton setTitle: @"StartViewControllerStartButtonTitle".commonLocalizedString
				 forState: UIControlStateNormal];
	startButton.frame = CGRectMake(0, offsetY, buttonsWidth, buttonsHeight);
	[startButton addTarget: self action: @selector(startAction:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: startButton];
	
	UIButton *loginButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	[loginButton setTitle: @"StartViewControllerLoginButtonTitle".commonLocalizedString
				 forState: UIControlStateNormal];
	loginButton.frame = CGRectMake(buttonsWidth, offsetY, buttonsWidth, buttonsHeight);
	[loginButton addTarget: self action: @selector(loginAction:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: loginButton];
}

#pragma mark - Actions

- (void) startAction: (id) sender {
	[kernel.checksManager openCheckCardViewController];
}

- (void) loginAction: (id) sender {
	[kernel.viewControllersManager openLoginViewController];
}

@end
