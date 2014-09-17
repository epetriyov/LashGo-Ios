//
//  LoginViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 30.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LoginViewController.h"

#import "AuthorizationManager.h"
#import "Common.h"
#import "CryptoUtils.h"
#import "FontFactory.h"
#import "UIView+CGExtension.h"
#import "ViewFactory.h"

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController

- (void) loadView {
	[super loadView];
	
	_titleBarView.titleLabel.text = @"LoginViewControllerTitle".commonLocalizedString;
	_titleBarView.backgroundColor = [UIColor clearColor];
	
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage: [ViewFactory sharedFactory].loginViewControllerBgImage];
	[self.view insertSubview:backgroundImageView atIndex: 0];
	
	//Configure welcome text
	float offsetY = self.contentFrame.origin.y;
	if ([Common is568hMode] == NO) {
		offsetY += 50;
	} else {
		offsetY += 92;
	}
	
	UILabel *welcomeLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY, self.view.frame.size.width, 25)];
	welcomeLabel.backgroundColor = [UIColor clearColor];
	welcomeLabel.font = [FontFactory fontWithType: FontTypeLoginWelcomeText];
	welcomeLabel.text = @"LoginViewControllerWelcomeText".commonLocalizedString;
	welcomeLabel.textAlignment = NSTextAlignmentCenter;
	welcomeLabel.textColor = [FontFactory fontColorForType: FontTypeLoginWelcomeText];
	[self.view addSubview: welcomeLabel];
	
	offsetY += welcomeLabel.frame.size.height + 25;
	
	//Configure bg for fields
	UIView *formView = [[UIView alloc] initWithFrame: CGRectMake(0, offsetY, self.view.frame.size.width, 87)];
	formView.backgroundColor = [UIColor colorWithWhite: 1.0 alpha: 229.0/255.0];
	[self.view addSubview: formView];
	
	float separatorOffsetX = 59;
	float separatorHeight = 1.0 / [UIScreen mainScreen].scale;
	
	UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(separatorOffsetX, formView.frame.size.height / 2,
																formView.frame.size.width - separatorOffsetX, separatorHeight)];
	separator.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 161.0/255.0];
	[formView addSubview: separator];
	
	//Configure icons for fields
	float formOffsetX = 18;
	float formOffsetY = 12;
	
	UIImageView *emailImageView = [[UIImageView alloc] initWithImage: [ViewFactory sharedFactory].iconEmail];
	emailImageView.frameOrigin = CGPointMake(formOffsetX, formOffsetY);
	[formView addSubview: emailImageView];
	
	formOffsetY += emailImageView.frame.size.height + 15;
	
	UIImageView *passwordImageView = [[UIImageView alloc] initWithImage: [ViewFactory sharedFactory].iconPassword];
	passwordImageView.frameOrigin = CGPointMake(formOffsetX, formOffsetY);
	[formView addSubview: passwordImageView];
	
	//Configure fields
	formOffsetX += emailImageView.frame.size.width + 17;
	
	UITextField *emailField = [[UITextField alloc] initWithFrame: CGRectMake(formOffsetX, 0,
																			 formView.frame.size.width - formOffsetX, 40)];
	emailField.delegate = self;
	emailField.centerY = emailImageView.center.y;
	emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	emailField.backgroundColor = [UIColor clearColor];
	emailField.font = [FontFactory fontWithType: FontTypeLoginInputField];
	emailField.textColor = [FontFactory fontColorForType: FontTypeLoginInputField];
	emailField.placeholder = @"LoginViewControllerLoginPlaceholder".commonLocalizedString;
	[formView addSubview: emailField];
	_emailField = emailField;
	
	UITextField *passwordField = [[UITextField alloc] initWithFrame: CGRectMake(formOffsetX, 0,
																				formView.frame.size.width - formOffsetX, 40)];
	passwordField.delegate = self;
	passwordField.centerY = passwordImageView.center.y;
	passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	passwordField.backgroundColor = [UIColor clearColor];
	passwordField.font = [FontFactory fontWithType: FontTypeLoginInputField];
	passwordField.textColor = [FontFactory fontColorForType: FontTypeLoginInputField];
	passwordField.placeholder = @"LoginViewControllerPassPlaceholder".commonLocalizedString;
	passwordField.secureTextEntry = YES;
	[formView addSubview: passwordField];
	_passwordField = passwordField;
	
	//Configure restore pass button
	offsetY += formView.frame.size.height;
	
	float restoreButtonWidth = 117;
	float restoreButtonHeight = 47;
	
	UIButton *restorePassButton = [[UIButton alloc] initWithFrame: CGRectMake(self.view.frame.size.width - restoreButtonWidth, offsetY, restoreButtonWidth, restoreButtonHeight)];
	restorePassButton.titleLabel.font = [FontFactory fontWithType: FontTypeLoginRestorePass];
	[restorePassButton setTitle: @"LoginViewControllerRestorePassBtnTitle".commonLocalizedString
					   forState: UIControlStateNormal];
	[restorePassButton setTitleColor: [FontFactory fontColorForType: FontTypeLoginRestorePass]
							forState: UIControlStateNormal];
	[restorePassButton addTarget: self action: @selector(restorePass:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: restorePassButton];
	
	//Configure actions
	offsetY += 54;
	
	UIButton *loginButton = [[ViewFactory sharedFactory] loginButtonWithTarget: self action: @selector(login:)];
	loginButton.frameY = offsetY;
	[loginButton addTarget: self action: @selector(login:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: loginButton];
	
	//Configure social bottom to top
	UIButton *fbButton = [[ViewFactory sharedFactory] loginFacebookButtonWithTarget: self action: @selector(loginWithFacebook:)];
	
	float offsetX = (self.view.frame.size.width - fbButton.frame.size.width * 3) / 2;
	offsetY = self.view.frame.size.height - fbButton.frame.size.height;
	
	fbButton.frameOrigin = CGPointMake(offsetX, offsetY);
	[self.view addSubview: fbButton];
	
	offsetX += fbButton.frame.size.width;
	
	UIButton *twButton = [[ViewFactory sharedFactory] loginTwitterButtonWithTarget: self action: @selector(loginWithTwitter:)];
	twButton.frameOrigin = CGPointMake(offsetX, offsetY);
	[self.view addSubview: twButton];
	
	offsetX += twButton.frame.size.width;
	
	UIButton *vkButton = [[ViewFactory sharedFactory] loginVkontakteButtonWithTarget: self action: @selector(loginWithVkontakte:)];
	vkButton.frameOrigin = CGPointMake(offsetX, offsetY);
	[self.view addSubview: vkButton];
	
	offsetY -= 15;
	
	UILabel *socialLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY, self.view.frame.size.width, 15)];
	socialLabel.backgroundColor = [UIColor clearColor];
	socialLabel.font = [FontFactory fontWithType: FontTypeLoginSocialLabel];
	socialLabel.text = @"LoginViewControllerSocialLabelTitle".commonLocalizedString;
	socialLabel.textAlignment = NSTextAlignmentCenter;
	socialLabel.textColor = [FontFactory fontColorForType: FontTypeLoginSocialLabel];
	[self.view addSubview: socialLabel];
}

#pragma mark - Actions

- (void) restorePass: (id) sender {
	
}

- (void) login: (id) sender {
	LGLoginInfo *loginInfo = [[LGLoginInfo alloc] init];
	loginInfo.login = _emailField.text;
	loginInfo.passwordHash = _passwordField.text.md5;
	
	[[AuthorizationManager sharedManager] loginUsingLashGo: loginInfo];
//	[[AuthorizationManager sharedManager] registerUsingLashGo: loginInfo];
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
}

#pragma mark - TextField delegate implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
