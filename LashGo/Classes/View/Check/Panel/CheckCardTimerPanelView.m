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
}

@end

@implementation CheckCardTimerPanelView

- (void) setTimeLeft:(NSTimeInterval)timeLeft {
	_timeLeft = timeLeft;
	
	int minutesLeft = timeLeft / 60;
	int secondsLeft = ((int)timeLeft) % 60;
	_timeLeftLabel.text = [NSString stringWithFormat: @"%02d:%02d", minutesLeft, secondsLeft];
	
}

- (instancetype) initWithFrame:(CGRect)frame mode:(CheckCardTimerPanelMode) mode {
    self = [super initWithFrame:frame];
    if (self) {
		self.mode = mode;
		
		float offsetX = frame.size.width / 2 - 30;
		_icon = [[UIImageView alloc] initWithImage: [ViewFactory sharedFactory].timerCheckOpenImage];
		_icon.frameX = offsetX;
		[self addSubview: _icon];
		
		offsetX += _icon.frame.size.width;
		
		_timeLeftLabel = [[UILabel alloc] initWithFrame: CGRectMake(offsetX, 0, 50, _icon.frame.size.height)];
		_timeLeftLabel.backgroundColor = [UIColor clearColor];
		_timeLeftLabel.font = [FontFactory fontWithType: FontTypeVoteTimer];
		_timeLeftLabel.textAlignment = NSTextAlignmentCenter;
		_timeLeftLabel.textColor = [FontFactory fontColorForType: FontTypeVoteTimer];
		[self addSubview: _timeLeftLabel];
		
		UIButton *shareButton;
		UIButton *mobButton;
		
		switch (self.mode) {
			case CheckCardTimerPanelModeDark:
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
		[self addSubview: shareButton];
		
		mobButton.frameX = frame.size.width - mobButton.frame.size.width;
		[mobButton setTitle: @"5" forState: UIControlStateNormal];
		[self addSubview: mobButton];
		
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
