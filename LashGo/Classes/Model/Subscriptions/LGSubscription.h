//
//  LGSubscription.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGUser.h"

@interface LGSubscription : NSObject

@property (nonatomic, assign) int32_t uid;
@property (nonatomic, strong) LGUser *user;
@property (nonatomic, assign) BOOL isSubscribed;

@end
