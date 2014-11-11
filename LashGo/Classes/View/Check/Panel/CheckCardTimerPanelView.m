//
//  CheckCardTimerPanelView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckCardTimerPanelView.h"

#import "FontFactory.h"
#import "ViewFactory.h"
#import "UIView+CGExtension.h"

@interface CheckCardTimerPanelView () {
	UIImageView *_icon;
	UILabel *_timeLeftLabel;
	
	UIButton *_playersButton;
}

@end

@implementation CheckCardTimerPanelView

@dynamic playersCount;

- (int32_t) playersCount {
	return [_playersButton.titleLabel.text intValue];
}

- (void) setPlayersCount:(int32_t)playersCount {
	[_playersButton setTitle: [NSString stringWithFormat: @"%d", playersCount] forState: UIControlStateNormal];
}

- (void) setTimeLeft:(NSTimeInterval)timeLeft {
	_timeLeft = timeLeft;
	
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

#pragma mark - Overrides

- (instancetype) initWithFrame:(CGRect)frame mode:(CheckCardTimerPanelMode) mode {
    self = [super initWithFrame:frame];
    if (self) {
		self.mode = mode;
		
		float offsetX = frame.size.width / 2 - 30;
		_icon = [[UIImageView alloc] initWithImage: [ViewFactory sharedFactory].timerCheckOpenImage];
		_icon.frameX = offsetX;
		[self addSubview: _icon];
		
		offsetX += _icon.frame.size.width;
		
		_timeLeftLabel = [[UILabel alloc] initWithFrame: CGRectMake(offsetX, 0, 60, _icon.frame.size.height)];
		_timeLeftLabel.backgroundColor = [UIColor clearColor];
		_timeLeftLabel.font = [FontFactory fontWithType: FontTypeVoteTimer];
		_timeLeftLabel.textAlignment = NSTextAlignmentCenter;
		_timeLeftLabel.textColor = [FontFactory fontColorForType: FontTypeVoteTimer];
		[self addSubview: _timeLeftLabel];
		
		UIButton *shareButton;
		UIButton *mobButton;
		
		switch (self.mode) {
			case CheckCardTimerPanelModeDark:
				self.hidden = YES;
				shareButton = [[ViewFactory sharedFactory] counterShareDark: nil action: nil];
				mobButton = [[ViewFactory sharedFactory] counterMobDark: nil action: nil];
				break;
			default:
				shareButton = [[ViewFactory sharedFactory] counterShare: nil action: nil];
				mobButton = [[ViewFactory sharedFactory] counterMob: nil action: nil];
				break;
		}
		
		shareButton.frameX = 8;
		[shareButton setTitle: @"7" forState: UIControlStateNormal];
		shareButton.hidden = YES;
		[self addSubview: shareButton];
		
		mobButton.frameX = frame.size.width - mobButton.frame.size.width;
		[mobButton setTitle: @"0" forState: UIControlStateNormal];
		[self addSubview: mobButton];
		_playersButton = mobButton;
		
//		UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 80, 30)];
//		btn.backgroundColor = [UIColor blueColor];
//		btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//		btn.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
//		[btn setImage: [ViewFactory sharedFactory].timerCheckOpenImage forState: UIControlStateNormal];
//		[btn setTitle: @"7" forState: UIControlStateNormal];
//		btn.titleLabel.font = [UIFont systemFontOfSize: 5];
//		[self addSubview:btn];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
	if (self = [self initWithFrame: frame mode: CheckCardTimerPanelModeLight]) {
		
	}
	return self;
}

- (void) setTimerHidden: (BOOL) hidden {
	_icon.hidden = hidden;
	_timeLeftLabel.hidden = hidden;
}

@end
