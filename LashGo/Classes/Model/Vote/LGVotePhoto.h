//
//  LGVotePhoto.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 28.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGPhoto.h"

@interface LGVotePhoto : NSObject

@property (nonatomic, strong) LGPhoto *photo;
@property (nonatomic, assign) BOOL isShown;
@property (nonatomic, assign) BOOL isVoted;

@end
