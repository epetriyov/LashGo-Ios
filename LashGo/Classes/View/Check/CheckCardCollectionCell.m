//
//  CheckCardCollectionCell.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckCardCollectionCell.h"
#import "FontFactory.h"

#import "Common.h"

NSString *const kCheckCardCollectionCellReusableId = @"kCheckCardCollectionCellReusableId";

@interface CheckCardCollectionCell () {
	CheckDetailView *_checkView;
	CheckDetailView *_userPhotoView;
	NSTimer *_progressTimer;
}

@end

@implementation CheckCardCollectionCell

@dynamic mainImage, secondImage;
@dynamic type;

#pragma mark - Properties

- (UIImage *) mainImage {
	return _checkView.image;
}

- (void) setMainImage:(UIImage *)mainImage {
	_checkView.image = mainImage;
}

- (UIImage *) secondImage {
	return _userPhotoView.image;
}

- (void) setSecondImage:(UIImage *)secondImage {
	_userPhotoView.image = secondImage;
}

- (CheckDetailType) type {
	return _checkView.type;
}

- (void) setType:(CheckDetailType) type {
	_checkView.type = type;
}

- (void) setCheck:(LGCheck *)check {
	_check = check;
	_textLabel.text = check.name;
	_detailTextLabel.text = check.descr;
	[self refresh];
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
		
		float cvOffsetX = 58;
		
		UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(cvOffsetX, offsetY,
																				   self.contentView.frame.size.width - cvOffsetX * 2, 204)];
		scrollView.clipsToBounds = NO;
		scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, scrollView.frame.size.height);
		scrollView.delegate = self;
		scrollView.pagingEnabled = YES;
		scrollView.showsHorizontalScrollIndicator = NO;
		[self.contentView addSubview: scrollView];
		
		CGRect checkViewFrame = CGRectMake(0, 0, 204, 204);
		
		_checkView = [[CheckDetailView alloc] initWithFrame: checkViewFrame
												  imageCaps: 18 progressLineWidth: 10];
		[scrollView addSubview: _checkView];
		
		checkViewFrame.origin.x += checkViewFrame.size.width;
		
		_userPhotoView = [[CheckDetailView alloc] initWithFrame: checkViewFrame
													  imageCaps: 18 progressLineWidth: 10];
		_userPhotoView.displayPreview = YES;
		[scrollView addSubview: _userPhotoView];
		
		[Common logScaleAndParamsForTwoSizes: 16 and: 23];
		
		offsetY += scrollView.frame.size.height;
		
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
    }
    return self;
}

- (void) refresh {
	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
	
	if (now > _check.closeDate) {
		self.type = CheckDetailTypeClosed;
		[_progressTimer invalidate];
		_progressTimer = nil;
	} else {
		if (now > _check.voteDate) {
			self.type = CheckDetailTypeVote;
		} else {
			self.type = CheckDetailTypeOpen;
		}
		if ([_progressTimer isValid] == NO) {
			_progressTimer = [NSTimer scheduledTimerWithTimeInterval: 5 target: self selector:@selector(refresh)
															userInfo:nil repeats:YES];
		}
	}
	
	CGFloat progress = 0;
	
	if (self.type == CheckDetailTypeOpen) {
		progress = fdim(now, _check.startDate) / _check.duration;
	} else if (self.type == CheckDetailTypeVote) {
		progress = fdim(now, _check.voteDate) / _check.voteDuration;
	}
	_checkView.progressValue = progress;
	_userPhotoView.progressValue = progress;
}

- (NSString *) reuseIdentifier {
	return kCheckCardCollectionCellReusableId;
}

#pragma mark - UIScrollViewDelegate implementation

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	_checkView.displayPreview = scrollView.contentOffset.x > 0;
//	if (scrollView.contentOffset.x < scrollView.frame.size.width) {
		_userPhotoView.displayPreview = scrollView.contentOffset.x < scrollView.frame.size.width;
//	}
	
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
