//
//  VoteAction.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 28.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGVoteAction.h"

#import "LGVotePhoto.h"

@implementation LGVoteAction

- (NSDictionary *) JSONObject {
	NSMutableArray *photoUIDs = [[NSMutableArray alloc] initWithCapacity: [self.votePhotos count]];
	for (LGVotePhoto *votePhoto in self.votePhotos) {
		[photoUIDs addObject: @(votePhoto.photo.uid)];
	}
	return @{@"photoIds" :		photoUIDs,
			 @"votedPhotoId" :	@(self.votedPhotoUID),
			 @"checkId" :		@(self.checkUID)};
}

@end
