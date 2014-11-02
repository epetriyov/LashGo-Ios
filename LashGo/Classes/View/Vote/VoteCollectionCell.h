//
//  VoteCollectionCell.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 02.11.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "VotePanelView.h"

@interface VoteCollectionCell : UICollectionViewCell

@property (nonatomic, weak) id<VotePanelViewDelegate> delegate;

- (void) refreshWithVotePhotos: (NSArray *) votePhotos;

@end
