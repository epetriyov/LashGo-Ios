//
//  LoginViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 30.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LoginViewController.h"

#import "AlertViewManager.h"
#import "AuthorizationManager.h"
#import "Common.h"
#import "CryptoUtils.h"
#import "FontFactory.h"
#import "Kernel.h"
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
		offsetY += 0;
	} else {
		offsetY += 72;
	}
	
	UILabel *welcomeLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY, self.view.frame.size.width, 25)];
	welcomeLabel.backgroundColor = [UIColor clearColor];
	welcomeLabel.font = [FontFactory fontWithType: FontTypeLoginWelcomeText];
	welcomeLabel.text = @"LoginViewControllerWelcomeText".commonLocalizedString;
	welcomeLabel.textAlignment = NSTextAlignmentCenter;
	welcomeLabel.textColor = [FontFactory fontColorForType: FontTypeLoginWelcomeText];
	[self.view addSubview: welcomeLabel];
	
	offsetY += welcomeLabel.frame.size.height;
	
	if ([Common is568hMode] == NO) {
		offsetY += 5;
	} else {
		offsetY += 25;
	}
	
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
	emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
	emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	emailField.backgroundColor = [UIColor clearColor];
	emailField.font = [FontFactory fontWithType: FontTypeLoginInputField];
	emailField.textColor = [FontFactory fontColorForType: FontTypeLoginInputField];
	emailField.placeholder = @"LoginViewControllerLoginPlaceholder".commonLocalizedString;
	emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	emailField.autocorrectionType = UITextAutocorrectionTypeNo;
	emailField.keyboardType = UIKeyboardTypeEmailAddress;
	[formView addSubview: emailField];
	_emailField = emailField;
	
	UITextField *passwordField = [[UITextField alloc] initWithFrame: CGRectMake(formOffsetX, 0,
																				formView.frame.size.width - formOffsetX, 40)];
	passwordField.delegate = self;
	passwordField.centerY = passwordImageView.center.y;
	passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
	offsetY += 34;
	
	UILabel *licenseText = [[UILabel alloc] initWithFrame: CGRectMake(10, offsetY,
																	  CGRectGetWidth(self.view.bounds) - 20, 35)];
	licenseText.backgroundColor = [UIColor clearColor];
	licenseText.font = [FontFactory fontWithType: FontTypeLoginRestorePass];
	licenseText.numberOfLines = 2;
	licenseText.textColor = [FontFactory fontColorForType: FontTypeLoginRestorePass];
	licenseText.text = @"LoginVCLicenseText".commonLocalizedString;
	[self.view addSubview: licenseText];
	
	offsetY += 20;
	
	UIButton *termsOfUseButton = [[UIButton alloc] initWithFrame: CGRectMake(0, offsetY, CGRectGetWidth(self.view.bounds), 35)];
	termsOfUseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	termsOfUseButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 0, 0);
	termsOfUseButton.titleLabel.font = [FontFactory fontWithType: FontTypeLoginLicense];
	[termsOfUseButton setTitle: @"LoginVCTermsOfUseBtnTitle".commonLocalizedString
					   forState: UIControlStateNormal];
	[termsOfUseButton setTitleColor: [FontFactory fontColorForType: FontTypeLoginLicense]
							forState: UIControlStateNormal];
	[termsOfUseButton addTarget: self action: @selector(termsOfUseAction:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: termsOfUseButton];
	
	offsetY += 35;
	
	UIButton *privacyPolicyButton = [[UIButton alloc] initWithFrame: CGRectMake(0, offsetY, CGRectGetWidth(self.view.bounds), 35)];
	privacyPolicyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	privacyPolicyButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 10, 0);
	privacyPolicyButton.titleLabel.font = [FontFactory fontWithType: FontTypeLoginLicense];
	[privacyPolicyButton setTitle: @"LoginVCPrivacyPolicyBtnTitle".commonLocalizedString
					  forState: UIControlStateNormal];
	[privacyPolicyButton setTitleColor: [FontFactory fontColorForType: FontTypeLoginLicense]
						   forState: UIControlStateNormal];
	[privacyPolicyButton addTarget: self action: @selector(privacyPolicyAction:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: privacyPolicyButton];
	
	offsetY = CGRectGetMaxY(privacyPolicyButton.frame) - 5;
	
	float buttonsGaps = 10;
	float buttonsWidth = CGRectGetWidth(self.view.bounds) / 2 - buttonsGaps * 2;
	float buttonsHeight = 44;
	
	UIButton *loginButton = [[ViewFactory sharedFactory] loginButtonWithTarget: self action: @selector(login:)];
	loginButton.frame = CGRectMake(buttonsGaps, offsetY, buttonsWidth, buttonsHeight);
	[self.view addSubview: loginButton];
	
	UIButton *registerButton = [[ViewFactory sharedFactory] loginButtonWithTarget: self
																		   action: @selector(registration:)];
	registerButton.frame = CGRectMake(CGRectGetMaxX(loginButton.frame) + buttonsGaps * 2, offsetY,
									  buttonsWidth, buttonsHeight);
	[registerButton setTitle: @"LoginViewControllerRegisterBtnTitle".commonLocalizedString
					forState: UIControlStateNormal];
	[self.view addSubview: registerButton];
	
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

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear: animated];
	
	[_emailField resignFirstResponder];
	[_passwordField resignFirstResponder];
	_passwordField.text = @"";
}

#pragma mark - Actions

- (void) restorePass: (id) sender {
	[kernel.userManager openRecoverViewController];
}

- (void) termsOfUseAction: (id) sender {
	[kernel.userManager openEULAViewController];
}

- (void) privacyPolicyAction: (id) sender {
	[kernel.userManager openPrivacyPolicyViewController];
}

- (void) login: (id) sender {
	if ([Common isEmptyString: _emailField.text] == YES ||
		[Common isEmptyString: _passwordField.text] == YES) {
		[[AlertViewManager sharedManager] showAlertEmptyFields];
		return;
	}
	LGLoginInfo *loginInfo = [[LGLoginInfo alloc] init];
	loginInfo.login = _emailField.text;
	loginInfo.passwordHash = _passwordField.text.md5;
	
	[[AuthorizationManager sharedManager] loginUsingLashGo: loginInfo];
}

- (void) registration: (id) sender {
	if ([Common isEmptyString: _emailField.text] == YES ||
		[Common isEmptyString: _passwordField.text] == YES) {
		[[AlertViewManager sharedManager] showAlertEmptyFields];
		return;
	}
	LGLoginInfo *loginInfo = [[LGLoginInfo alloc] init];
	loginInfo.login = _emailField.text;
	loginInfo.passwordHash = _passwordField.text.md5;
	
	[[AuthorizationManager sharedManager] registerUsingLashGo: loginInfo];
}

- (void) loginWithFacebook: (id) sender {
//	[[NSNotificationCenter defaultCenter] addObserver: self
//											 selector: @selector(authorizationSuccess)
//												 name: kAuthorizationNotification
//											   object: nil];
	[[AuthorizationManager sharedManager] loginUsingFacebook];
}

- (void) loginWithTwitter: (id) sender {
//	[[NSNotificationCenter defaultCenter] addObserver: self
//											 selector: @selector(authorizationSuccess)
//												 name: kAuthorizationNotification
//											   object: nil];
	[[AuthorizationManager sharedManager] loginUsingTwitterFromViewController: self];
}

- (void) loginWithVkontakte: (id) sender {
//	[[NSNotificationCenter defaultCenter] addObserver: self
//											 selector: @selector(authorizationSuccess)
//												 name: kAuthorizationNotification
//											   object: nil];
	[[AuthorizationManager sharedManager] loginUsingVkontakteFromViewController: self];
}

//- (void) authorizationSuccess {
//	[[NSNotificationCenter defaultCenter] removeObserver: self name: kAuthorizationNotification object: nil];
//}

#pragma mark - TextField delegate implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
