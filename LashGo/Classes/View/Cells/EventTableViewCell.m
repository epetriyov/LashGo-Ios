//
//  EventTableViewCell.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 20.12.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "EventTableViewCell.h"

#import "FontFactory.h"
#import "UIButton+LGImages.h"

@implementation EventTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.imageView.clipsToBounds = YES;
		
		self.textLabel.font = [FontFactory fontWithType: FontTypeCommentsCellTitle];
		self.textLabel.textColor = [FontFactory fontColorForType: FontTypeCommentsCellTitle];
		self.textLabel.numberOfLines = 2;
		
		self.detailTextLabel.font = [FontFactory fontWithType: FontTypeCommentsCellDescription];
		self.detailTextLabel.textColor = [FontFactory fontColorForType: FontTypeCommentsCellDescription];
    }
    return self;
}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	self.imageView.layer.cornerRadius = self.imageView.layer.bounds.size.width / 2;
}

- (void) setCheckPhotoUrl: (NSString *) checkPhotoURL {
	if (checkPhotoURL != nil) {
		if (self.accessoryView == nil) {
			UIButton *accessoryButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 43, 43)];
			[accessoryButton addTarget: self action: @selector(checkPhotoAction:)
					  forControlEvents: UIControlEventTouchUpInside];
			self.accessoryView = accessoryButton;
		}
		[((UIButton *)self.accessoryView) loadWebImageWithSizeThatFitsName: checkPhotoURL
															   placeholder: nil];
	} else {
		self.accessoryView = nil;
	}
}

- (void) checkPhotoAction: (UIButton *) sender {
	[self.delegate eventCheckActionFor: self];
}

@end
