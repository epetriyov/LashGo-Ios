//
//  VoteViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 17.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "VoteViewController.h"

#import "CheckSimpleDetailView.h"
#import "Common.h"
#import "FontFactory.h"
#import "Kernel.h"
#import "UIImageView+LGImagesExtension.h"
#import "VotePanelView.h"

#define kCheckBarHeight 76

@interface VoteViewController () {
	CheckSimpleDetailView __weak *_checkView;
	UILabel __weak *_checkTitleLabel;
	UILabel __weak *_checkDescriptionLabel;
	UILabel *_timeLeftLabel;
	
	NSTimer *_progressTimer;
}

@property (nonatomic, readonly) CGRect waitViewFrame;

@end

@implementation VoteViewController

#pragma mark - Properties

- (void) setCheck:(LGCheck *)check {
	if (_check != check) {
		_check = check;
		
		if (check != nil) {
			_checkTitleLabel.text = check.name;
			_checkDescriptionLabel.text = check.descr;
			[_checkView.imageView loadWebImageWithSizeThatFitsName: check.taskPhotoUrl placeholder: nil];
		}
	}
}

#pragma mark - Overrides

- (CGRect) waitViewFrame {
	CGRect frame = self.contentFrame;
	frame.origin.y += kCheckBarHeight;
	frame.size.height -= kCheckBarHeight;
	return frame;
}

- (void) loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor colorWithRed: 235.0/255.0 green: 236.0/255.0 blue: 238.0/255.0
												alpha: 1.0];
	
	_titleBarView.titleLabel.text = @"VoteViewControllerTitle".commonLocalizedString;
	
	float offsetY = self.contentFrame.origin.y;
	
	UIView *checkDetailsView = [[UIView alloc] initWithFrame: CGRectMake(0, offsetY, self.view.frame.size.width,
																		 kCheckBarHeight)];
	checkDetailsView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview: checkDetailsView];
	
	float checkViewOffsetX = 10;
	float checkViewOffsetY = 7;
	
	CheckSimpleDetailView *checkView = [[CheckSimpleDetailView alloc] initWithFrame: CGRectMake(checkViewOffsetX,
																					checkViewOffsetY,
																					44, 44)
											  imageCaps: 4 progressLineWidth: 2];
	checkView.type = CheckDetailTypeVote;
	[checkView.imageView loadWebImageWithSizeThatFitsName: _check.taskPhotoUrl placeholder: nil];
	[checkDetailsView addSubview: checkView];
	_checkView = checkView;
	
	checkViewOffsetX += checkView.frame.size.width + 11;
	
	UILabel *checkTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(checkViewOffsetX, checkViewOffsetY,
																		  checkDetailsView.frame.size.width - checkViewOffsetX, 15)];
	checkTitleLabel.font = [FontFactory fontWithType: FontTypeVoteCheckTitle];
	checkTitleLabel.textColor = [FontFactory fontColorForType: FontTypeVoteCheckTitle];
	checkTitleLabel.text = _check.name;
	[checkDetailsView addSubview: checkTitleLabel];
	_checkTitleLabel = checkTitleLabel;
	
	checkViewOffsetY += checkTitleLabel.frame.size.height + 3;
	
	UILabel *checkDescriptionLabel = [[UILabel alloc] initWithFrame: CGRectMake(checkViewOffsetX, checkViewOffsetY,
																				checkTitleLabel.frame.size.width,
																				checkDetailsView.frame.size.height - checkViewOffsetY)];
	checkDescriptionLabel.font = [FontFactory fontWithType: FontTypeVoteCheckDescription];
	checkDescriptionLabel.textColor = [FontFactory fontColorForType: FontTypeVoteCheckDescription];
	checkDescriptionLabel.numberOfLines = 3;
	checkDescriptionLabel.text = _check.descr;
	[checkDescriptionLabel sizeToFit];
	[checkDetailsView addSubview: checkDescriptionLabel];
	_checkDescriptionLabel = checkDescriptionLabel;
	
	_timeLeftLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, _checkView.frame.origin.y + _checkView.frame.size.height, checkViewOffsetX, 26)];
	_timeLeftLabel.backgroundColor = [UIColor clearColor];
	_timeLeftLabel.font = [FontFactory fontWithType: FontTypeVoteTimer];
	_timeLeftLabel.textAlignment = NSTextAlignmentCenter;
	_timeLeftLabel.textColor = [FontFactory fontColorForType: FontTypeVoteTimer];
	[checkDetailsView addSubview: _timeLeftLabel];
	
	offsetY += checkDetailsView.frame.size.height;
	
	VotePanelView *panelView = [[VotePanelView alloc] initWithFrame: CGRectMake(0, offsetY,
																				self.view.frame.size.width,
																				self.view.frame.size.height - offsetY)];
	[self.view addSubview: panelView];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
	[kernel.checksManager getVotePhotos];
	
	if ([_progressTimer isValid] == NO) {
		_progressTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector:@selector(refresh)
														userInfo:nil repeats:YES];
	}
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear: animated];
	[_progressTimer invalidate];
}

#pragma mark - Methods

- (void) setTimeLeft:(NSTimeInterval)timeLeft {
	int minutesLeft = timeLeft / 60;
	int secondsLeft = ((int)timeLeft) % 60;
	_timeLeftLabel.text = [NSString stringWithFormat: @"%02d:%02d", minutesLeft, secondsLeft];
	
}

- (void) refresh {
	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
	
	if (now > _check.closeDate) {
		_checkView.type = CheckDetailTypeClosed;
	}
	
	if (_checkView.type == CheckDetailTypeVote) {
		[self setTimeLeft: fdim(_check.closeDate, now)];
	}
}

@end
