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
																			  imageCaps: 7 progressLineWidth: 3];
		checkView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[bgView addSubview: checkView];
		_checkView = checkView;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	float offsetX = 10;
	
	CGRect textLabelFrame = self.textLabel.frame;
	float oldOffsetX = textLabelFrame.origin.x;
	
	textLabelFrame.origin.x = offsetX;
	textLabelFrame.size.width -= ABS(offsetX - oldOffsetX);
	self.textLabel.frame = textLabelFrame;
}

+ (CGFloat) height {
	return 134 + kCaps * 2;
}

@end
