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

@implementation CheckCardCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		CGFloat offsetY = 0;
		
		_textLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY, self.contentView.frame.size.width, 20)];
		_textLabel.font = [FontFactory fontWithType: FontTypeCheckCardTitle];
		_textLabel.textAlignment = NSTextAlignmentCenter;
		_textLabel.textColor = [FontFactory fontColorForType: FontTypeCheckCardTitle];
		_textLabel.backgroundColor = [UIColor redColor];
		[self.contentView addSubview: _textLabel];
		
		offsetY += _textLabel.frame.size.height;
		CGFloat descrHeight = 60;
		
		_detailTextLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, self.contentView.frame.size.height - descrHeight, self.contentView.frame.size.width, descrHeight)];
		_detailTextLabel.font = [FontFactory fontWithType: FontTypeCheckCardDescription];
		_detailTextLabel.textAlignment = NSTextAlignmentCenter;
		_detailTextLabel.textColor = [FontFactory fontColorForType: FontTypeCheckCardDescription];
		_detailTextLabel.backgroundColor = [UIColor greenColor];
		[self.contentView addSubview: _detailTextLabel];
		
		CheckDetailView *cv = [[CheckDetailView alloc] initWithFrame: CGRectMake(0, offsetY, self.contentView.frame.size.width, _detailTextLabel.frame.origin.y - offsetY)];
		cv.backgroundColor = [UIColor blueColor];
		[self.contentView addSubview: cv];
    }
    return self;
}

- (NSString *) reuseIdentifier {
	return kCheckCardCollectionCellReusableId;
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
