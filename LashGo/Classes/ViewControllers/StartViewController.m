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
#import "FontFactory.h"
#import "Kernel.h"
#import "UIColor+CustomColors.h"
#import "UIView+CGExtension.h"
#import "ViewFactory.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void) loadView {
	[super loadView];
	
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage: [ViewFactory sharedFactory].startViewControllerBgImage];
	[self.view insertSubview: backgroundImageView atIndex: 0];
	
	UIImageView *gradientImageView = [[UIImageView alloc] initWithImage: [ViewFactory sharedFactory].startViewControllerGradientImage];
	gradientImageView.frameWidth = backgroundImageView.frame.size.width;
	[backgroundImageView addSubview: gradientImageView];
	
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage: [ViewFactory sharedFactory].lgLogoImage];
	logoImageView.frameX = 175;
	logoImageView.frameY = 57;
	[self.view addSubview: logoImageView];
	
	UIImageView *frameImageView = [[UIImageView alloc] initWithImage: [ViewFactory sharedFactory].startViewControllerFrameImage];
	frameImageView.frameY = 176;
	frameImageView.centerX = self.view.frame.size.width / 2;
	[self.view addSubview: frameImageView];
	
	UILabel *sloganLabel = [[UILabel alloc] initWithFrame: CGRectMake(178, 71, 120, 22)];
	sloganLabel.backgroundColor = [UIColor clearColor];
	sloganLabel.font = [FontFactory fontWithType: FontTypeSlogan];
	sloganLabel.text = @"StartViewControllerSlogan".commonLocalizedString;
	sloganLabel.textAlignment = NSTextAlignmentLeft;
	sloganLabel.textColor = [FontFactory fontColorForType: FontTypeSlogan];
	[frameImageView addSubview: sloganLabel];
	
	
	float buttonsWidth = self.view.frame.size.width / 2;
	float buttonsHeight = 44;
	float offsetY = self.view.frame.size.height - buttonsHeight;
	
	UIButton *startButton = [[UIButton alloc] initWithFrame: CGRectMake(buttonsWidth, offsetY, buttonsWidth, buttonsHeight)];
	startButton.backgroundColor = [UIColor colorWithWhite: 0 alpha: 1.0];
	startButton.titleLabel.font = [FontFactory fontWithType: FontTypeStartScreenButtons];
	[startButton setTitleColor: [FontFactory fontColorForType: FontTypeStartScreenButtons]
					  forState: UIControlStateNormal];
	[startButton setTitle: @"StartViewControllerStartButtonTitle".commonLocalizedString
				 forState: UIControlStateNormal];
	[startButton addTarget: self action: @selector(startAction:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: startButton];
	
	UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, offsetY, buttonsWidth, buttonsHeight)];
	loginButton.backgroundColor = [UIColor colorWithAppColorType: AppColorTypeSecondaryTint];
	loginButton.titleLabel.font = [FontFactory fontWithType: FontTypeStartScreenButtons];
	[loginButton setTitleColor: [FontFactory fontColorForType: FontTypeStartScreenButtons]
					  forState: UIControlStateNormal];
	[loginButton setTitle: @"StartViewControllerLoginButtonTitle".commonLocalizedString
				 forState: UIControlStateNormal];
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
