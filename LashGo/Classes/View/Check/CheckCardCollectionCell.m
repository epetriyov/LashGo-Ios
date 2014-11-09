//
//  CheckCardCollectionCell.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckCardCollectionCell.h"
#import "FontFactory.h"

#import "CheckCardTimerPanelView.h"
#import "Common.h"
#import "UIImageView+LGImagesExtension.h"

NSString *const kCheckCardCollectionCellReusableId = @"kCheckCardCollectionCellReusableId";

@interface CheckCardCollectionCell () <CheckDetailViewDelegate> {
	CheckDetailView *_checkView;
	CheckCardTimerPanelView *_panelView;
//	NSTimer *_progressTimer;
}

@end

@implementation CheckCardCollectionCell

@dynamic type;

#pragma mark - Properties

- (CheckDetailType) type {
	return _checkView.type;
}

- (void) setType:(CheckDetailType) type {
	if (_checkView.type != type) {
		_checkView.type = type;
	}
}

- (void) setCheck:(LGCheck *)check {
	_check = check;
	_textLabel.text = check.name;
	_detailTextLabel.text = check.descr;
	
	[_checkView setImageWithURLString: check.taskPhotoUrl];
	[_checkView setUserImagesWithCheck: check];
	[self refresh];
	
	_panelView.playersCount = check.counters.playersCount;
}

#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		BOOL is568hMode = [Common is568hMode];
		CGFloat offsetY;
		if (is568hMode == NO) {
			offsetY = 10;
		} else {
			offsetY = 21;
		}
		
		_textLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY, self.contentView.frame.size.width, 20)];
		_textLabel.font = [FontFactory fontWithType: FontTypeCheckCardTitle];
		_textLabel.textAlignment = NSTextAlignmentCenter;
		_textLabel.textColor = [FontFactory fontColorForType: FontTypeCheckCardTitle];
		_textLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview: _textLabel];
		
		offsetY += _textLabel.frame.size.height;
		if (is568hMode == NO) {
			offsetY += 16;
		} else {
			offsetY += 24;
		}
		
		CGRect checkViewFrame = CGRectMake(0, offsetY,
										   self.contentView.frame.size.width, 204);
		
		_checkView = [[CheckDetailView alloc] initWithFrame: checkViewFrame
												  imageCaps: 18 progressLineWidth: 10];
		_checkView.delegate = self;
		[self.contentView addSubview: _checkView];
		
		checkViewFrame.origin.x += checkViewFrame.size.width;
		
		offsetY += _checkView.frame.size.height;
		
		if (is568hMode == NO) {
			offsetY += 16;
		} else {
			offsetY += 23;
		}
		
		int numberOfLines = 3;
		CGFloat lineHeight;
		if (is568hMode == NO) {
			lineHeight = 16;
		} else {
			lineHeight = 23;
		}
		
		_detailTextLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY, self.contentView.frame.size.width, lineHeight * numberOfLines)];
		_detailTextLabel.font = [FontFactory fontWithType: FontTypeCheckCardDescription];
		_detailTextLabel.numberOfLines = numberOfLines;
		_detailTextLabel.textAlignment = NSTextAlignmentCenter;
		_detailTextLabel.textColor = [FontFactory fontColorForType: FontTypeCheckCardDescription];
		_detailTextLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview: _detailTextLabel];
		
		float panelHeight = 31;
		
		_panelView = [[CheckCardTimerPanelView alloc] initWithFrame: CGRectMake(0, self.contentView.frame.size.height - panelHeight, self.contentView.frame.size.width, panelHeight)];
		_panelView.hidden = YES;
		[self.contentView addSubview: _panelView];
    }
    return self;
}

- (void) refresh {
	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
	
	CheckDetailType currentType;
	if (now > _check.closeDate) {
		currentType = CheckDetailTypeClosed;
//		[_progressTimer invalidate];
//		_progressTimer = nil;
	} else {
		if (now > _check.voteDate) {
			currentType = CheckDetailTypeVote;
		} else {
			currentType = CheckDetailTypeOpen;
		}
//		if ([_progressTimer isValid] == NO) {
//			_progressTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector:@selector(refresh)
//															userInfo:nil repeats:YES];
//		}
	}
	if (self.type != currentType) {
		self.type = currentType;
		[_checkView setUserImagesWithCheck: self.check];
		_panelView.hidden = currentType == CheckDetailTypeClosed;
	}
	
	CGFloat progress = 0;
	
	if (self.type == CheckDetailTypeOpen) {
		progress = fdim(now, _check.startDate) / _check.duration;
		_panelView.timeLeft = fdim(_check.voteDate, now);
		if (self.check.userPhoto != nil) {
			[_checkView setUserImageWithURLString: _check.userPhoto.url];
		} else {
			[_checkView setUserImageWithImage: _check.currentPickedUserPhoto];
		}
	} else if (self.type == CheckDetailTypeVote) {
		_panelView.timeLeft = fdim(_check.closeDate, now);
		progress = fdim(now, _check.voteDate) / _check.voteDuration;
	}
	_checkView.progressValue = progress;
}

- (NSString *) reuseIdentifier {
	return kCheckCardCollectionCellReusableId;
}

#pragma mark - CheckDetailViewDelegate implementation

- (void) makePhotoAction {
	[self.delegate pickPhotoFor: self.check];
}

- (void) voteAction {
	[self.delegate voteFor: self.check];
}

- (void) imageAction {
	[self.delegate openImageFor: self.check];
}

- (void) userImageAction {
	[self.delegate openUserImageFor: self.check];
}

- (void) sendUserImageAction {
	[self.delegate sendUserImageFor: self.check];
}

- (void) winnerImageAction {
	[self.delegate openWinnerImageFor: self.check];
}

@end
