//
//  EventTableViewCell.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 20.12.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "EventTableViewCell.h"

#import "FontFactory.h"

@implementation EventTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.imageView.clipsToBounds = YES;
		
		self.textLabel.font = [FontFactory fontWithType: FontTypeCommentsCellTitle];
		self.textLabel.textColor = [FontFactory fontColorForType: FontTypeCommentsCellTitle];
		self.textLabel.numberOfLines = 3;
		
		self.detailTextLabel.font = [FontFactory fontWithType: FontTypeCommentsCellDescription];
		self.detailTextLabel.textColor = [FontFactory fontColorForType: FontTypeCommentsCellDescription];
    }
    return self;
}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	self.imageView.layer.cornerRadius = self.imageView.layer.bounds.size.width / 2;
}

@end
