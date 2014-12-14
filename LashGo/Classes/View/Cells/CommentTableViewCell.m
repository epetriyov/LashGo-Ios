//
//  CommentTableViewCell.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.12.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CommentTableViewCell.h"

#import "FontFactory.h"

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.textLabel.font = [FontFactory fontWithType: FontTypeCommentsCellTitle];
		self.textLabel.textColor = [FontFactory fontColorForType: FontTypeCommentsCellTitle];
		
		self.detailTextLabel.font = [FontFactory fontWithType: FontTypeCommentsCellDescription];
		self.detailTextLabel.textColor = [FontFactory fontColorForType: FontTypeCommentsCellDescription];
		self.detailTextLabel.numberOfLines = 3;
    }
    return self;
}

@end
