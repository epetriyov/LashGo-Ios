//
//  PhotoCountersPanelView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.12.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "PhotoCountersPanelView.h"

#import "FontFactory.h"
#import "ViewFactory.h"
#import "UIView+CGExtension.h"

@interface PhotoCountersPanelView ()

@end

@implementation PhotoCountersPanelView

@dynamic commentsCount;

- (int32_t) commentsCount {
	return [_commentsButton.titleLabel.text intValue];
}

- (void) setCommentsCount:(int32_t)playersCount {
	[_commentsButton setTitle: [NSString stringWithFormat: @"%d", playersCount] forState: UIControlStateNormal];
}

#pragma mark - Overrides

- (id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
    if (self) {
		UIButton *commentsButton = [[ViewFactory sharedFactory] counterCommentDark: nil action: nil];
		
		commentsButton.frameX = frame.size.width - commentsButton.frame.size.width;
		[commentsButton setTitle: @"0" forState: UIControlStateNormal];
		[self addSubview: commentsButton];
		_commentsButton = commentsButton;
		
//		UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 80, 30)];
//		btn.backgroundColor = [UIColor blueColor];
//		btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//		btn.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
//		[btn setImage: [ViewFactory sharedFactory].timerCheckOpenImage forState: UIControlStateNormal];
//		[btn setTitle: @"7" forState: UIControlStateNormal];
//		btn.titleLabel.font = [UIFont systemFontOfSize: 5];
//		[self addSubview:btn];
    }
    return self;
}

@end
