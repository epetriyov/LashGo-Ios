//
//  VoteAction.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 28.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "JSONSerializableProtocol.h"

@interface LGVoteAction : NSObject <JSONSerializableProtocol>

@property (nonatomic, strong) NSArray *photoUIDs;
@property (nonatomic, assign) int64_t votedPhotoUID;
@property (nonatomic, assign) int32_t checkUID;

@end
