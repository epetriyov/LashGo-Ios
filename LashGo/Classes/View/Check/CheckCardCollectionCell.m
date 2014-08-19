//
//  CheckCardCollectionCell.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckCardCollectionCell.h"
#import "CheckDetailView.h"
#import "FontFactory.h"

NSString *const kCheckCardCollectionCellReusableId = @"kCheckCardCollectionCellReusableId";

@interface CheckCardCollectionCell () {
	CheckDetailView *_cv;
}

@end

@implementation CheckCardCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		CGFloat offsetY = 21;
		
		_textLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY, self.contentView.frame.size.width, 20)];
		_textLabel.font = [FontFactory fontWithType: FontTypeCheckCardTitle];
		_textLabel.textAlignment = NSTextAlignmentCenter;
		_textLabel.textColor = [FontFactory fontColorForType: FontTypeCheckCardTitle];
		_textLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview: _textLabel];
		
		offsetY += _textLabel.frame.size.height + 24;
		
		float cvOffsetX = 58;
		_cv = [[CheckDetailView alloc] initWithFrame: CGRectMake(cvOffsetX, offsetY,
																 self.contentView.frame.size.width - cvOffsetX * 2, 204)
										   imageCaps: 18 progressLineWidth: 10];
		[self.contentView addSubview: _cv];
		
		offsetY += _cv.frame.size.height + 23;
		
		CGFloat descrHeight = 60;
		
		_detailTextLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, self.contentView.frame.size.height - descrHeight, self.contentView.frame.size.width, descrHeight)];
		_detailTextLabel.font = [FontFactory fontWithType: FontTypeCheckCardDescription];
		_detailTextLabel.textAlignment = NSTextAlignmentCenter;
		_detailTextLabel.textColor = [FontFactory fontColorForType: FontTypeCheckCardDescription];
		_detailTextLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview: _detailTextLabel];
		
		[NSTimer scheduledTimerWithTimeInterval:1 target: self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
    return self;
}

- (NSString *) reuseIdentifier {
	return kCheckCardCollectionCellReusableId;
}

- (void) updateProgress {
	static CGFloat a = 0;
	a += 0.1;
	_cv.progressValue = a;
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
