//
//  VoteCollectionCell.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 02.11.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "VoteCollectionCell.h"

@interface VoteCollectionCell () <VotePanelViewDelegate> {
	VotePanelView *_panelView;
}

@end

@implementation VoteCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		VotePanelView *panelView = [[VotePanelView alloc] initWithFrame: self.contentView.bounds];
		panelView.delegate = self;
		[self.contentView addSubview: panelView];
		_panelView = panelView;
    }
    return self;
}

#pragma mark - Methods

- (void) refreshWithVotePhotos: (NSArray *) votePhotos {
	[_panelView refreshWithVotePhotos: votePhotos];
}

#pragma mark - VotePanelViewDelegate implementation

- (void) voteWithIndex: (ushort) index {
	[self.delegate voteWithIndex: index];
}

- (void) openPhotoWithIndex: (ushort) index {
	[self.delegate openPhotoWithIndex: index];
}

- (void) openNext {
	[self.delegate openNext];
}

@end
