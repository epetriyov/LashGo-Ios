//
//  CheckListTableViewCell.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.08.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckListTableViewCell.h"

#import "FontFactory.h"

#define kCaps 8

@interface CheckListTableViewCell () {
	UILabel *_timeLeftLabel;
}

@end

@implementation CheckListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		
		[self.textLabel setFont: [FontFactory fontWithType: FontTypeCheckListCellTitle]];
		self.textLabel.textColor = [FontFactory fontColorForType: FontTypeCheckListCellTitle];
		
		[self.detailTextLabel setFont: [FontFactory fontWithType: FontTypeCheckListCellDescription]];
		self.detailTextLabel.textColor = [FontFactory fontColorForType: FontTypeCheckListCellDescription];
		self.detailTextLabel.numberOfLines = 5;

		float caps = kCaps;
		
		CGRect cardFrame = CGRectOffset(self.contentView.bounds, caps, caps);
		cardFrame.size.width -= caps * 2;
		cardFrame.size.height -= caps * 2;
		
		UIView *bgView = [[UIView alloc] initWithFrame: cardFrame];
		bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		bgView.backgroundColor = [UIColor colorWithWhite: 250.0/255.0 alpha: 1];
		[self.contentView insertSubview: bgView atIndex: 0];
		
		float checkViewCaps = 10;
		float checkViewWidth = 82;
		float checkViewOffsetX = bgView.frame.size.width - (checkViewWidth + checkViewCaps);
		
		CheckSimpleDetailView *checkView = [[CheckSimpleDetailView alloc] initWithFrame: CGRectMake(checkViewOffsetX,
																									checkViewCaps,
																									checkViewWidth,
																									checkViewWidth)
																			  imageCaps: 7 progressLineWidth: 4];
		checkView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[bgView addSubview: checkView];
		_checkView = checkView;
		
		checkViewCaps += checkViewWidth + 11;
		
		_timeLeftLabel = [[UILabel alloc] initWithFrame: CGRectMake(checkViewOffsetX, checkViewCaps,
																	checkViewWidth, 15)];
		_timeLeftLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		_timeLeftLabel.backgroundColor = [UIColor clearColor];
		_timeLeftLabel.font = [FontFactory fontWithType: FontTypeVoteTimer];
		_timeLeftLabel.textAlignment = NSTextAlignmentCenter;
		_timeLeftLabel.textColor = [FontFactory fontColorForType: FontTypeVoteTimer];
		[bgView addSubview: _timeLeftLabel];
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//	
//    // Configure the view for the selected state
//}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	float offsetX = 17;
	float width = _checkView.frame.origin.x - offsetX;
	offsetX += kCaps;
	
	CGRect textLabelFrame = CGRectMake(offsetX, 13 + kCaps, width, 20);
	
	self.textLabel.frame = textLabelFrame;
	self.textLabel.backgroundColor = [UIColor clearColor];
	
	textLabelFrame.origin.y += textLabelFrame.size.height + 10;
	textLabelFrame.size.height = self.contentView.frame.size.height - (textLabelFrame.origin.y + 21 + kCaps);
	
	self.detailTextLabel.frame = textLabelFrame;
	self.detailTextLabel.backgroundColor = [UIColor clearColor];
	[self.detailTextLabel sizeToFit];
}

- (void) setTimeLeft:(NSTimeInterval)timeLeft {
	if (timeLeft > 0) {
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
		_timeLeftLabel.hidden = NO;
	} else {
		_timeLeftLabel.hidden = YES;
	}
}

+ (CGFloat) height {
	return 134 + kCaps * 2;
}

- (void) refresh {
	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
	
	if (now > _check.closeDate) {
		self.checkView.type = CheckDetailTypeClosed;
	} else {
		if (now > _check.voteDate) {
			self.checkView.type = CheckDetailTypeVote;
		} else {
			self.checkView.type = CheckDetailTypeOpen;
		}
	}
	
	CGFloat progress = 0;
	CGFloat timeLeft = 0;
	
	if (self.checkView.type == CheckDetailTypeOpen) {
		progress = fdim(now, _check.startDate) / _check.duration;
		timeLeft = fdim(_check.voteDate, now);
	} else if (self.checkView.type == CheckDetailTypeVote) {
		progress = fdim(now, _check.voteDate) / _check.voteDuration;
		timeLeft = fdim(_check.closeDate, now);
	}
	_checkView.progressValue = progress;
	[self setTimeLeft: timeLeft];
}

@end
