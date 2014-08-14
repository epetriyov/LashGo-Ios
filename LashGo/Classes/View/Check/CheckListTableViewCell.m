//
//  CheckListTableViewCell.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.08.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckListTableViewCell.h"

#import "FontFactory.h"

@implementation CheckListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		[self.textLabel setFont: [FontFactory fontWithType: FontTypeCheckListCellTitle]];
		[self.detailTextLabel setFont: [FontFactory fontWithType: FontTypeCheckListCellDescription]];
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

@end
