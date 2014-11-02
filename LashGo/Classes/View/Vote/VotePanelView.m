//
//  VotePanelView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 25.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "VotePanelView.h"

#import "UIButton+LGImages.h"
#import "ViewFactory.h"
#import "LGVotePhoto.h"

@interface VotePanelView () {
	NSArray *_photoButtons;
	NSArray *_selectionButtons;
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
	} else {
		_likeButton.hidden = NO;
		_nextButton.hidden = YES;
	}
}

#pragma mark - Overrides

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_selectionButtons = [[NSMutableArray alloc] initWithCapacity: 4];
		
		float caps = 8;
		float space = 4;
		
		float imageWidth = (frame.size.width - caps * 2 - space) / 2;
		float imageHeight = (frame.size.height - caps * 2 - space) / 2;
		float offsetX = caps;
		float offsetY = caps;
		
		CGRect btnFrame;
		CGRect imageFrame = CGRectMake(offsetX, offsetY, imageWidth, imageHeight);
		UIButton *_photo0ImageButton = [[UIButton alloc] initWithFrame: imageFrame];
		[_photo0ImageButton addTarget: self action: @selector(photoAction:)
					 forControlEvents: UIControlEventTouchUpInside];
		[self addSubview: _photo0ImageButton];
		UIButton *btn0 = [[ViewFactory sharedFactory] votePhotoSelectButtonWithIndex: 0 target:self
																			 action: @selector(photoSelectAction:)];
		btnFrame = btn0.frame;
		btnFrame.origin.x = offsetX;
		btnFrame.origin.y = offsetY;
		btn0.frame = btnFrame;
		[self addSubview: btn0];
		
		offsetX += _photo0ImageButton.frame.size.width + space;
		
		imageFrame = CGRectMake(offsetX, offsetY, imageWidth, imageHeight);
		UIButton *_photo1ImageButton = [[UIButton alloc] initWithFrame: imageFrame];
		[_photo1ImageButton addTarget: self action: @selector(photoAction:)
					 forControlEvents: UIControlEventTouchUpInside];
		[self addSubview: _photo1ImageButton];
		UIButton *btn1 = [[ViewFactory sharedFactory] votePhotoSelectButtonWithIndex: 1 target:self
																   action: @selector(photoSelectAction:)];
		btnFrame.origin.x = self.frame.size.width - btnFrame.size.width - caps;
		btn1.frame = btnFrame;
		[self addSubview: btn1];
		
		offsetX = _photo0ImageButton.frame.origin.x;
		offsetY += _photo0ImageButton.frame.size.height + space;
		
		imageFrame = CGRectMake(offsetX, offsetY, imageWidth, imageHeight);
		UIButton *_photo2ImageButton = [[UIButton alloc] initWithFrame: imageFrame];
		[_photo2ImageButton addTarget: self action: @selector(photoAction:)
					 forControlEvents: UIControlEventTouchUpInside];
		[self addSubview: _photo2ImageButton];
		UIButton *btn2 = [[ViewFactory sharedFactory] votePhotoSelectButtonWithIndex: 2 target:self
																   action: @selector(photoSelectAction:)];
		btnFrame.origin.x = offsetX;
		btnFrame.origin.y = self.frame.size.height - btnFrame.size.height - caps;
		btn2.frame = btnFrame;
		[self addSubview: btn2];
		
		offsetX += _photo2ImageButton.frame.size.width + space;
		
		imageFrame = CGRectMake(offsetX, offsetY, imageWidth, imageHeight);
		UIButton *_photo3ImageButton = [[UIButton alloc] initWithFrame: imageFrame];
		[_photo3ImageButton addTarget: self action: @selector(photoAction:)
					 forControlEvents: UIControlEventTouchUpInside];
		[self addSubview: _photo3ImageButton];
		UIButton *btn3 = [[ViewFactory sharedFactory] votePhotoSelectButtonWithIndex: 3 target:self
																   action: @selector(photoSelectAction:)];
		btnFrame.origin.x = btn1.frame.origin.x;
		btn3.frame = btnFrame;
		[self addSubview: btn3];
		
		_photoButtons = [[NSArray alloc] initWithObjects: _photo0ImageButton, _photo1ImageButton, _photo2ImageButton, _photo3ImageButton, nil];
		_selectionButtons = [[NSArray alloc] initWithObjects: btn0, btn1, btn2, btn3, nil];
		
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
	for (ushort i = 0; i < [_selectionButtons count]; ++i) {
		UIButton *button = [_selectionButtons objectAtIndex: i];
		if (button.selected == YES) {
			[self.delegate voteWithIndex: i];
			return;
		}
	}
}

- (void) nextAction: (id) sender {
	[self.delegate openNext];
}

- (void) photoAction: (id) sender {
	NSUInteger index = [_photoButtons indexOfObject: sender];
	[self.delegate openPhotoWithIndex: index];
}

- (void) photoSelectAction: (id) sender {
	_likeButton.userInteractionEnabled = YES;
	for (UIButton *button in _selectionButtons) {
		button.selected = (button == sender);
	}
}

#pragma mark - Methods

- (void) refreshWithVotePhotos: (NSArray *) votePhotos {
	VotePanelType displayType = VotePanelTypeLike;
	for (ushort i = 0; i < [_photoButtons count]; ++i) {
		UIButton *photoButton = _photoButtons[i];
		UIButton *selectionButton = _selectionButtons[i];
		if (i < [votePhotos count]) {
			photoButton.hidden = NO;
			selectionButton.hidden = NO;
			
			LGVotePhoto *votePhoto = votePhotos[i];
			[photoButton loadWebImageWithSizeThatFitsName: votePhoto.photo.url placeholder: nil];
			
			selectionButton.enabled = !votePhoto.isVoted;
			selectionButton.selected = NO;
			selectionButton.userInteractionEnabled = !votePhoto.isShown;
			
			_likeButton.userInteractionEnabled = votePhoto.isShown;
			
			if (votePhoto.isShown == YES) {
				displayType = VotePanelTypeNext;
			}
		} else {
			photoButton.hidden = YES;
			selectionButton.hidden = YES;
		}
	}
	self.type = displayType;
}

@end
