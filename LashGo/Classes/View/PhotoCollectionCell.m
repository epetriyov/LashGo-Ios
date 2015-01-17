//
//  PhotoCollectionCell.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "PhotoCollectionCell.h"

#import "AlertViewManager.h"
#import "UIImageView+LGImagesExtension.h"
#import "ViewFactory.h"

@interface PhotoCollectionCell () {
	UIButton *_complainButton;
	LGPhoto *_photo;
	UIImageView *_imageView;
	
	UIImageView *_winnerLed;
}

@end

@implementation PhotoCollectionCell

@dynamic photo;

- (LGPhoto *) photo {
	return _photo;
}

- (void) setPhoto:(LGPhoto *)photo {
	_photo = photo;
	
	_winnerLed.hidden = !_photo.isWinner;
	[_imageView loadWebImageWithSizeThatFitsName: _photo.url placeholder: nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_imageView = [[UIImageView alloc] initWithFrame: self.bounds];
		_imageView.contentMode = UIViewContentModeCenter;
		[self.contentView addSubview: _imageView];
		
		CGFloat size = 44;
		CGRect frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) - size - 5,
								  CGRectGetHeight(self.contentView.bounds) - size - 5, size, size);
		
		UIImageView *winnerLed = [[UIImageView alloc] initWithFrame: frame];
		winnerLed.contentMode = UIViewContentModeBottomRight;
		winnerLed.image = [ViewFactory sharedFactory].checkDetailWinnerLed;
		[self.contentView addSubview: winnerLed];
		_winnerLed = winnerLed;
		
		//Work as complain button but should be banned indicator by design
//		UIButton *complainButton = [[ViewFactory sharedFactory] complainButton: self
//																		action: @selector(complainAction:)];
//		complainButton.frame = CGRectOffset(complainButton.frame,
//											CGRectGetWidth(self.contentView.bounds) - CGRectGetWidth(complainButton.frame) - 5,
//											CGRectGetHeight(self.contentView.bounds) - CGRectGetHeight(complainButton.frame) - 5);
//		complainButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//		complainButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//		[self.contentView addSubview: complainButton];
//		_complainButton = complainButton;
    }
    return self;
}

- (void) complainAction: (id) sender {
	[[AlertViewManager sharedManager] showAlertComplainConfirmWithContext: self.photo];
}

@end
