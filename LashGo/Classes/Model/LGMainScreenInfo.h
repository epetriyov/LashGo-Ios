//
//  LGMainScreenInfo.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.06.15.
//  Copyright (c) 2015 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGMainScreenInfo : NSObject

@property (nonatomic, assign) int32_t tasksCount;
@property (nonatomic, assign) int32_t newsCount;
@property (nonatomic, assign) int32_t subscribesCount;
@property (nonatomic, assign) int32_t actionCount;

@end
