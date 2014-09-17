//
//  LGCheckCounters.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 17.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGCheckCounters : NSObject

@property (nonatomic, assign) int32_t sharesCount;
@property (nonatomic, assign) int32_t likesCount;
@property (nonatomic, assign) int32_t commentsCount;
@property (nonatomic, assign) int32_t playersCount;

@end
