//
//  SubscriptionTableViewCell.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 29.11.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "SubscriptionTableViewCell.h"

#import "FontFactory.h"
#import "ViewFactory.h"

@implementation SubscriptionTableViewCell

@dynamic isSubscribed;

- (BOOL) isSubscribed {
	return ((UIButton *)self.accessoryView).selected;
}

- (void) setIsSubscribed:(BOOL)isSubscribed {
	((UIButton *)self.accessoryView).selected = isSubscribed;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.imageView.clipsToBounds = YES;
		UIButton *accessoryButton = [ViewFactory sharedFactory].subscribeCellButton;
		[accessoryButton addTarget: self action: @selector(subscriptionAction:)
				  forControlEvents: UIControlEventTouchUpInside];
		self.accessoryView = accessoryButton;
		self.textLabel.font = [FontFactory fontWithType: FontTypeSubscriptionTitle];
		self.textLabel.textColor = [FontFactory fontColorForType: FontTypeSubscriptionTitle];
    }
    return self;
}

+ (CGFloat) height {
	return 52;
}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	self.imageView.layer.cornerRadius = self.imageView.layer.bounds.size.width / 2;
}
		 
- (void) subscriptionAction: (id) sender {
	[self.delegate subscriptionActionFor: self];
}

@end
