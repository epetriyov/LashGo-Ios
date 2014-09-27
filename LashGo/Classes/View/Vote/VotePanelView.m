//
//  VotePanelView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 25.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "VotePanelView.h"
#import "ViewFactory.h"

@interface VotePanelView () {
	NSMutableArray *photoButtons;
	UIButton *_likeButton;
	UIButton *_nextButton;
}

@end

@implementation VotePanelView

#pragma mark - Properties

- (void) setType:(VotePanelType)type {
	_type = type;
	
	if (type == VotePanelTypeNext) {
		_likeButton.hidden = YES;
		_nextButton.hidden = NO;
		for (UIButton *button in photoButtons) {
			button.enabled = !button.selected;
			button.selected = NO;
			button.userInteractionEnabled = NO;
		}
	} else {
		_likeButton.hidden = NO;
		_nextButton.hidden = YES;
		for (UIButton *button in photoButtons) {
			button.selected = !button.enabled;
			button.enabled = YES;
			button.userInteractionEnabled = YES;
		}
	}
}

#pragma mark - Overrides

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		photoButtons = [[NSMutableArray alloc] initWithCapacity: 4];
		
		float caps = 8;
		float space = 4;
		
		float imageWidth = (frame.size.width - caps * 2 - space) / 2;
		float imageHeight = (frame.size.height - caps * 2 - space) / 2;
		float offsetX = caps;
		float offsetY = caps;
		
		CGRect imageFrame = CGRectMake(offsetX, offsetY, imageWidth, imageHeight);
		_photo0ImageView = [[UIImageView alloc] initWithFrame: imageFrame];
		[self addSubview: _photo0ImageView];
		UIButton *btn = [[ViewFactory sharedFactory] votePhotoSelectButtonWithIndex: 0 target:self
																			 action: @selector(photoSelectAction:)];
		btn.frame = imageFrame;
		[photoButtons addObject: btn];
		[self addSubview: btn];
		
		offsetX += _photo0ImageView.frame.size.width + space;
		
		imageFrame = CGRectMake(offsetX, offsetY, imageWidth, imageHeight);
		_photo1ImageView = [[UIImageView alloc] initWithFrame: imageFrame];
		[self addSubview: _photo1ImageView];
		btn = [[ViewFactory sharedFactory] votePhotoSelectButtonWithIndex: 1 target:self
																   action: @selector(photoSelectAction:)];
		btn.frame = imageFrame;
		[photoButtons addObject: btn];
		[self addSubview: btn];
		
		offsetX = _photo0ImageView.frame.origin.x;
		offsetY += _photo0ImageView.frame.size.height + space;
		
		imageFrame = CGRectMake(offsetX, offsetY, imageWidth, imageHeight);
		_photo2ImageView = [[UIImageView alloc] initWithFrame: imageFrame];
		[self addSubview: _photo2ImageView];
		btn = [[ViewFactory sharedFactory] votePhotoSelectButtonWithIndex: 2 target:self
																   action: @selector(photoSelectAction:)];
		btn.frame = imageFrame;
		[photoButtons addObject: btn];
		[self addSubview: btn];
		
		offsetX += _photo2ImageView.frame.size.width + space;
		
		imageFrame = CGRectMake(offsetX, offsetY, imageWidth, imageHeight);
		_photo3ImageView = [[UIImageView alloc] initWithFrame: imageFrame];
		[self addSubview: _photo3ImageView];
		btn = [[ViewFactory sharedFactory] votePhotoSelectButtonWithIndex: 3 target:self
																   action: @selector(photoSelectAction:)];
		btn.frame = imageFrame;
		[photoButtons addObject: btn];
		[self addSubview: btn];
		
		CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
		_likeButton = [[ViewFactory sharedFactory] votePhotoLikeButtonWithTarget: self
																		  action: @selector(likeAction:)];
		_likeButton.center = center;
		_likeButton.userInteractionEnabled = NO;
		[self addSubview: _likeButton];
		
		_nextButton = [[ViewFactory sharedFactory] votePhotoNextButtonWithTarget: self
																		  action: @selector(nextAction:)];
		_nextButton.center = center;
		_nextButton.hidden = YES;
		[self addSubview: _nextButton];
    }
    return self;
}

- (void) likeAction: (id) sender {
	self.type = VotePanelTypeNext;
}

- (void) nextAction: (id) sender {
	self.type = VotePanelTypeLike;
}

- (void) photoSelectAction: (id) sender {
	_likeButton.userInteractionEnabled = YES;
	for (UIButton *button in photoButtons) {
		button.selected = (button == sender);
	}
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
