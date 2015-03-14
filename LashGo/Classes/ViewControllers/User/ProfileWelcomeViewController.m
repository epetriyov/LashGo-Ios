//
//  ProfileWelcomeViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 04.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ProfileWelcomeViewController.h"

#import "Common.h"
#import "FontFactory.h"
#import "UIColor+CustomColors.h"
#import "UIImageView+LGImagesExtension.h"
#import "ViewFactory.h"

@interface ProfileWelcomeViewController () {
	UIImageView *_avatarImageView;
}

@end

@implementation ProfileWelcomeViewController

- (void) loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	[_titleBarView removeFromSuperview];
	TitleBarView *tbView = [TitleBarView titleBarViewWithRightButtonWithText: @"TitleBarRightSaveBtnText".commonLocalizedString];
	tbView.backgroundColor = [UIColor clearColor];
	[tbView.backButton addTarget: self action: @selector(backAction:)
				forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: tbView];
	_titleBarView = tbView;
	
	_avatarImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 240)];
	_avatarImageView.backgroundColor = [UIColor colorWithAppColorType: AppColorTypeTint];
	_avatarImageView.contentMode = UIViewContentModeBottom;
	_avatarImageView.userInteractionEnabled = YES;
	[self.view insertSubview: _avatarImageView belowSubview: _titleBarView];
	[_avatarImageView loadWebImageWithSizeThatFitsName: self.user.avatar
										   placeholder: [ViewFactory sharedFactory].userProfileAvatarPlaceholder];
	
	float changeAvatarButtonHeight = 48;
	CGRect changeAvatarButtonRect = _avatarImageView.bounds;
	changeAvatarButtonRect.origin.y = changeAvatarButtonRect.size.height - changeAvatarButtonHeight;
	changeAvatarButtonRect.size.height = changeAvatarButtonHeight;
	
	UIButton *changeAvatarButton = [[ViewFactory sharedFactory] userChangeAvatarButtonWithTarget: self
																						  action: @selector(changeAvatarAction:)];
	changeAvatarButton.frame = changeAvatarButtonRect;
	[_avatarImageView addSubview: changeAvatarButton];
	
	float buttonsHeight = 44;
	float offsetX = 0;
	float offsetY = self.view.frame.size.height - buttonsHeight;
	
	UIButton *completeProfileButton = [[UIButton alloc] initWithFrame: CGRectMake(offsetX, offsetY,
																				 self.view.frame.size.width * 0.56,
																				  buttonsHeight)];
	completeProfileButton.backgroundColor = [UIColor colorWithRed: 1 green: 94.0/255.0 blue: 124.0/255.0 alpha: 1.0];
	completeProfileButton.titleLabel.font = [FontFactory fontWithType: FontTypeStartScreenButtons];
	[completeProfileButton setTitle: @"ProfileWelcomeViewControllerCompleteBtnTitle".commonLocalizedString
						   forState: UIControlStateNormal];
	[completeProfileButton setTitleColor: [FontFactory fontColorForType: FontTypeStartScreenButtons]
								forState: UIControlStateNormal];
	[completeProfileButton addTarget: self action: @selector(completeProfileAction:)
					forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: completeProfileButton];
	
	offsetX += completeProfileButton.frame.size.width;
	
	UIButton *continueProfileButton = [[UIButton alloc] initWithFrame: CGRectMake(offsetX, offsetY,
																				  self.view.frame.size.width - offsetX,
																				  buttonsHeight)];
	continueProfileButton.backgroundColor = [UIColor colorWithWhite: 151.0/255.0 alpha: 1.0];
	continueProfileButton.titleLabel.font = [FontFactory fontWithType: FontTypeStartScreenButtons];
	[continueProfileButton setTitle: @"ProfileWelcomeViewControllerContinueBtnTitle".commonLocalizedString
						   forState: UIControlStateNormal];
	[continueProfileButton setTitleColor: [FontFactory fontColorForType: FontTypeStartScreenButtons]
								forState: UIControlStateNormal];
	[continueProfileButton addTarget: self action: @selector(continueProfileAction:)
					forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: continueProfileButton];
}

#pragma mark - Action

- (void) changeAvatarAction: (id) sender {
	
}

- (void) completeProfileAction: (id) sender {
	
}

- (void) continueProfileAction: (id) sender {
	
}

@end
