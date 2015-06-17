//
//  LGUser.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "JSONSerializableProtocol.h"

@interface LGUser : NSObject <NSCoding, JSONSerializableProtocol>

@property (nonatomic, assign) int32_t uid;
@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *fio;
@property (nonatomic, strong) NSString *about;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSDate *birthDate;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *email;

@property (nonatomic, assign) int32_t userSubscribes;
@property (nonatomic, assign) int32_t userSubscribers;
@property (nonatomic, assign) int32_t checksCount;
@property (nonatomic, assign) int32_t commentsCount;
@property (nonatomic, assign) int32_t likesCount;

@property (nonatomic, assign) BOOL subscription;

@property (nonatomic, strong) NSDate *newsLastViewDate;
@property (nonatomic, strong) NSDate *subscriptionsLastViewDate;

@end
