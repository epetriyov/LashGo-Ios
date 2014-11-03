//
//  LGCheck.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGCheckCounters.h"
#import "LGPhoto.h"
#import "LGUser.h"

@interface LGCheck : NSObject

@property (nonatomic, assign) int64_t uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *descr;
@property (nonatomic, assign) NSTimeInterval startDate;
@property (nonatomic, assign) NSTimeInterval voteDate;
@property (nonatomic, assign) NSTimeInterval closeDate;

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval voteDuration;
@property (nonatomic, strong) NSString *taskPhotoUrl;

@property (nonatomic, strong) UIImage *currentPickedUserPhoto;

@property (nonatomic, strong) LGCheckCounters *counters;

@property (nonatomic, strong) LGPhoto *userPhoto;
@property (nonatomic, strong) LGUser *winnerInfo;
@property (nonatomic, strong) LGPhoto *winnerPhoto;

@end
