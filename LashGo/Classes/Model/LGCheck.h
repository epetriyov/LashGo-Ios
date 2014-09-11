//
//  LGCheck.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGCheck : NSObject

@property (nonatomic, assign) int64_t uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *descr;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) int32_t duration;
@property (nonatomic, assign) int32_t voteDuration;
@property (nonatomic, strong) NSString *taskPhotoUrl;

@end
