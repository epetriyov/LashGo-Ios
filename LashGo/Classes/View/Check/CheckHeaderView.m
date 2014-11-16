//
//  CheckHeaderView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 16.11.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckHeaderView.h"

#import "CheckSimpleDetailView.h"
#import "FontFactory.h"

@interface CheckHeaderView () {
	UILabel *_timeLeftLabel;
}

@property (nonatomic, readonly) UILabel *descriptionLabel;

@end

@implementation CheckHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor whiteColor];
		
		float checkViewOffsetX = 10;
		float checkViewOffsetY = 7;
		
		CheckSimpleDetailView *checkView = [[CheckSimpleDetailView alloc] initWithFrame: CGRectMake(checkViewOffsetX,
																									checkViewOffsetY,
																									44, 44)
																			  imageCaps: 4 progressLineWidth: 2];
		[self addSubview: checkView];
		_simpleDetailView = checkView;
		
		checkViewOffsetX += checkView.frame.size.width + 11;
		
		UILabel *checkTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(checkViewOffsetX, checkViewOffsetY,
																			  frame.size.width - checkViewOffsetX, 15)];
		checkTitleLabel.font = [FontFactory fontWithType: FontTypeVoteCheckTitle];
		checkTitleLabel.textColor = [FontFactory fontColorForType: FontTypeVoteCheckTitle];
		[self addSubview: checkTitleLabel];
		_titleLabel = checkTitleLabel;
		
		checkViewOffsetY += checkTitleLabel.frame.size.height + 3;
		
		UILabel *checkDescriptionLabel = [[UILabel alloc] initWithFrame: CGRectMake(checkViewOffsetX, checkViewOffsetY,
																					checkTitleLabel.frame.size.width,
																					frame.size.height - checkViewOffsetY)];
		checkDescriptionLabel.font = [FontFactory fontWithType: FontTypeVoteCheckDescription];
		checkDescriptionLabel.textColor = [FontFactory fontColorForType: FontTypeVoteCheckDescription];
		checkDescriptionLabel.numberOfLines = 3;
		[self addSubview: checkDescriptionLabel];
		_descriptionLabel = checkDescriptionLabel;
    }
    return self;
}

- (void) setDescriptionText: (NSString *) text {
	_descriptionLabel.text = text;
	[_descriptionLabel sizeToFit];
}

- (void) setTimeLeft:(NSTimeInterval)timeLeft {
	if (_timeLeftLabel == nil) {
		UILabel *timeLeftLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, self.simpleDetailView.frame.origin.y + self.simpleDetailView.frame.size.height,
																	self.titleLabel.frame.origin.x, 26)];
		timeLeftLabel.backgroundColor = [UIColor clearColor];
		timeLeftLabel.font = [FontFactory fontWithType: FontTypeVoteTimer];
		timeLeftLabel.textAlignment = NSTextAlignmentCenter;
		timeLeftLabel.textColor = [FontFactory fontColorForType: FontTypeVoteTimer];
		[self addSubview: timeLeftLabel];
		_timeLeftLabel = timeLeftLabel;
	}
	int hoursLeft = timeLeft / 3600;
	if (hoursLeft > 0) {
		int minutesLeft = (int)timeLeft % 3600 / 60;
		int secondsLeft = ((int)timeLeft) % 60;
		_timeLeftLabel.text = [NSString stringWithFormat: @"%02d:%02d:%02d", hoursLeft, minutesLeft, secondsLeft];
	} else {
		int minutesLeft = timeLeft / 60;
		int secondsLeft = ((int)timeLeft) % 60;
		_timeLeftLabel.text = [NSString stringWithFormat: @"%02d:%02d", minutesLeft, secondsLeft];
	}
}

@end
