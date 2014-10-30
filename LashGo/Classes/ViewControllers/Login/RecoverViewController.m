//
//  RecoverViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 25.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "RecoverViewController.h"

#import "Common.h"
#import "FontFactory.h"
#import "Kernel.h"
#import "UIView+CGExtension.h"
#import "ViewFactory.h"

@interface RecoverViewController () <UITextFieldDelegate> {
	UITextField __weak *_emailField;
}

@end

@implementation RecoverViewController

- (void) loadView {
	[super loadView];
	
	_titleBarView.titleLabel.text = @"RecoverViewControllerTitle".commonLocalizedString;
	_titleBarView.backgroundColor = [UIColor clearColor];
	
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage: [ViewFactory sharedFactory].loginViewControllerBgImage];
	[self.view insertSubview:backgroundImageView atIndex: 0];
	
	//Configure welcome text
	float offsetY = self.contentFrame.origin.y;
	if ([Common is568hMode] == NO) {
		offsetY += 30;
	} else {
		offsetY += 72;
	}
	
	UILabel *welcomeLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY, self.view.frame.size.width, 25)];
	welcomeLabel.backgroundColor = [UIColor clearColor];
	welcomeLabel.font = [FontFactory fontWithType: FontTypeLoginSocialLabel];
	welcomeLabel.text = @"RecoverViewControllerMessage".commonLocalizedString;
	welcomeLabel.textAlignment = NSTextAlignmentCenter;
	welcomeLabel.textColor = [FontFactory fontColorForType: FontTypeLoginWelcomeText];
	[self.view addSubview: welcomeLabel];
	
	offsetY += welcomeLabel.frame.size.height + 15;
	
	//Configure bg for fields
	UIView *formView = [[UIView alloc] initWithFrame: CGRectMake(0, offsetY, self.view.frame.size.width, 43)];
	formView.backgroundColor = [UIColor colorWithWhite: 1.0 alpha: 229.0/255.0];
	[self.view addSubview: formView];
	
	//Configure icons for fields
	float formOffsetX = 18;
	float formOffsetY = 12;
	
	UIImageView *emailImageView = [[UIImageView alloc] initWithImage: [ViewFactory sharedFactory].iconEmail];
	emailImageView.frameOrigin = CGPointMake(formOffsetX, formOffsetY);
	[formView addSubview: emailImageView];
	
	formOffsetY += emailImageView.frame.size.height + 15;
	
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
	emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	emailField.autocorrectionType = UITextAutocorrectionTypeNo;
	emailField.keyboardType = UIKeyboardTypeEmailAddress;
	[formView addSubview: emailField];
	_emailField = emailField;
	
	//Configure restore pass button
	offsetY += formView.frame.size.height;
	
	//Configure actions
	offsetY += 20;
	
	UIButton *recoverButton = [[ViewFactory sharedFactory] loginButtonWithTarget: self action: @selector(recoverAction:)];
	[recoverButton setTitle: @"RecoverViewControllerRecoverBtnTitle".commonLocalizedString forState: UIControlStateNormal];
	recoverButton.frameY = offsetY;
	[recoverButton addTarget: self action: @selector(recoverAction:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: recoverButton];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear: animated];
	[_emailField becomeFirstResponder];
}

#pragma mark - Actions

- (void) recoverAction: (id) sender {
	[kernel.userManager recoverPasswordWithEmail: _emailField.text];
}

#pragma mark - TextField delegate implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
