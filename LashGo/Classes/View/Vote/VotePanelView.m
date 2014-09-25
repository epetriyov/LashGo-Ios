//
//  VotePanelView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 25.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "VotePanelView.h"

@implementation VotePanelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		float caps = 8;
		float space = 4;
		
		float imageWidth = frame.size.width - caps * 2 - space;
		float imageHeight = imageWidth;
		float offsetX = caps;
		float offsetY = caps;
		
		_photo0ImageView = [[UIImageView alloc] initWithFrame: CGRectMake(offsetX, offsetY, imageWidth, imageHeight)];
		[self addSubview: _photo0ImageView];
		
		offsetX += _photo0ImageView.frame.size.width + space;
		
		_photo1ImageView = [[UIImageView alloc] initWithFrame: CGRectMake(offsetX, offsetY, imageWidth, imageHeight)];
		[self addSubview: _photo1ImageView];
		
		offsetX = _photo0ImageView.frame.origin.x;
		offsetY += _photo0ImageView.frame.size.height + space;
		
		_photo2ImageView = [[UIImageView alloc] initWithFrame: CGRectMake(offsetX, offsetY, imageWidth, imageHeight)];
		[self addSubview: _photo2ImageView];
		
		offsetX += _photo2ImageView.frame.size.width + space;
		
		_photo3ImageView = [[UIImageView alloc] initWithFrame: CGRectMake(offsetX, offsetY, imageWidth, imageHeight)];
		[self addSubview: _photo3ImageView];
    }
    return self;
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
