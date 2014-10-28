//
//  VoteAction.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 28.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGVoteAction.h"

@implementation LGVoteAction

- (NSDictionary *) JSONObject {
	return @{@"photoIds" :		self.photoUIDs,
			 @"votedPhotoId" :	@(self.votedPhotoUID),
			 @"checkId" :		@(self.checkUID)};
}

@end
