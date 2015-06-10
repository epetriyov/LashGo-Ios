//
//  CheckActionWinnerViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 10.06.15.
//  Copyright (c) 2015 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckActionWinnerViewController.h"

#import "Common.h"
#import "FontFactory.h"
#import "Kernel.h"
#import "NSDateFormatter+CustomFormats.h"
#import "UIButton+LGImages.h"
#import "UIColor+CustomColors.h"
#import "UIImageView+LGImagesExtension.h"
#import "ViewFactory.h"

#import "CheckSimpleDetailView.h"
#import "CheckDetailWinnerOverlay.h"

@interface CheckActionWinnerViewController () {
	CheckSimpleDetailView *_checkView;
	CheckDetailWinnerOverlay *_winnerOverlay;
}

@end

@implementation CheckActionWinnerViewController

- (void) loadView {
	[super loadView];
	
	[_titleBarView removeFromSuperview];
	UIButton *iconButton = [[ViewFactory sharedFactory] titleBarIconButtonWithTarget: self
																			  action: @selector(iconAction:)];
	
	if (self.check != nil) {
		[iconButton loadWebImageWithSizeThatFitsName: self.check.taskPhotoUrl placeholder: nil];
	}
	
	TitleBarView *tbView = [TitleBarView titleBarViewWithLeftSecondaryButton: iconButton
																 rightButton: nil
														rightSecondaryButton: nil];
	if (self.check != nil) {
		tbView.titleLabel.text = self.check.name;
	}
	
	[tbView.backButton addTarget: self action: @selector(backAction:)
				forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: tbView];
	_titleBarView = tbView;
	
	
	
	CGRect contentBounds = self.contentFrame;
	
	CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
	gradientLayer.frame = contentBounds;
	gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:61.0/255.0
														  green:66.0/255.0
														   blue:90.0/255.0 alpha:1.0].CGColor,
							 (__bridge id)[UIColor colorWithRed:24.0/255.0
														  green:28.0/255.0
														   blue:34.0/255.0 alpha:1.0].CGColor];
	//		gradientLayer.startPoint = CGPointMake(0,0.5);
	//		gradientLayer.endPoint = CGPointMake(1,0.5);
	[self.view.layer insertSublayer: gradientLayer atIndex: 0];
	
	CGFloat offsetY = CGRectGetMinY(contentBounds);
	float textLabelHeight = ceilf((CGRectGetHeight(self.view.bounds) - 480) / 2) + 40;
	
	UILabel *textLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY, CGRectGetWidth(contentBounds),
																	textLabelHeight)];
	textLabel.font = [FontFactory fontWithType: FontTypeCheckCardTitle];
	textLabel.textAlignment = NSTextAlignmentCenter;
	textLabel.textColor = [FontFactory fontColorForType: FontTypeCheckCardTitle];
	textLabel.backgroundColor = [UIColor clearColor];
	textLabel.numberOfLines = 2;
	textLabel.adjustsFontSizeToFitWidth = YES;
	textLabel.text = @"CheckWinnerHelp".commonLocalizedString;
	[self.view addSubview: textLabel];
	
	offsetY += CGRectGetHeight(textLabel.frame);
	
	CGRect checkViewFrame = CGRectMake(0, offsetY,
									   CGRectGetWidth(contentBounds),
									   CGRectGetWidth(contentBounds) - 116);
	
	_checkView = [[CheckSimpleDetailView alloc] initWithFrame: checkViewFrame
											  imageCaps: 18 progressLineWidth: 10];
	[_checkView.imageView loadWebImageWithSizeThatFitsName: self.check.winnerPhoto.url placeholder: nil];
//	_checkView.delegate = self;
	[self.view addSubview: _checkView];
	
	CheckDetailWinnerOverlay *winnerOverlay = [[CheckDetailWinnerOverlay alloc] initWithFrame: _checkView.imageView.frame];
//	winnerOverlay.delegate = self;
	[_checkView addSubview: winnerOverlay];
	_winnerOverlay = winnerOverlay;
	
	_winnerOverlay.fio.text = self.check.winnerPhoto.user.fio;
	
	
	offsetY += CGRectGetHeight(checkViewFrame);
	CGRect labelsFrame = CGRectMake(0, offsetY, CGRectGetWidth(contentBounds),
									ceilf((CGRectGetMaxY(contentBounds) - offsetY) / 2));
	
	UILabel *winnerTextLabel = [[UILabel alloc] initWithFrame: labelsFrame];
	winnerTextLabel.font = [FontFactory fontWithType: FontTypeCheckCardTitle];
	winnerTextLabel.textAlignment = NSTextAlignmentCenter;
	winnerTextLabel.textColor = [FontFactory fontColorForType: FontTypeVoteTimer];
	winnerTextLabel.backgroundColor = [UIColor clearColor];
	winnerTextLabel.text = @"CheckWinnerText".commonLocalizedString;
	[self.view addSubview: winnerTextLabel];
	
	labelsFrame.origin.y += CGRectGetHeight(winnerTextLabel.frame);
	
	UILabel *startDateLabel = [[UILabel alloc] initWithFrame: labelsFrame];
	startDateLabel.backgroundColor = [UIColor clearColor];
	startDateLabel.font = [FontFactory fontWithType: FontTypeVoteTimer];
	startDateLabel.textAlignment = NSTextAlignmentCenter;
	startDateLabel.textColor = [FontFactory fontColorForType: FontTypeCountersTitle];
	[self.view addSubview: startDateLabel];
	
	NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithDisplayMediumDateFormat];
	startDateLabel.text = [dateFormatter stringFromDate:
						   [NSDate dateWithTimeIntervalSinceReferenceDate: self.check.startDate]];
}

#pragma mark - Actions

- (void) iconAction: (id) sender {
	if (self.check != nil) {
		[kernel.checksManager openCheckCardViewControllerForCheckUID: self.check.uid];
	}
}

@end
