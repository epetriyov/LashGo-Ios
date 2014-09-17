//
//  CheckCardCountersPanelView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 17.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckCardCountersPanelView.h"

@interface CheckCardCountersPanelView () {
	UILabel *_timeLeftLabel;
}

@end

@implementation CheckCardCountersPanelView

- (void) setTimeLeft:(NSTimeInterval)timeLeft {
	_timeLeft = timeLeft;
	
	int minutesLeft = timeLeft / 60;
	int secondsLeft = ((int)timeLeft) % 60;
	_timeLeftLabel.text = [NSString stringWithFormat: @"%02d:%02d", minutesLeft, secondsLeft];
	
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_timeLeftLabel = [[UILabel alloc] initWithFrame: self.bounds];
		_timeLeftLabel.backgroundColor = [UIColor clearColor];
		_timeLeftLabel.textColor = [UIColor whiteColor];
		[self addSubview: _timeLeftLabel];
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
