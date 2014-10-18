//
//  LGUser.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGUser : NSObject {
	int32_t uid;
	NSString *login;
	NSString *fio;
	NSString *about;
	NSString *city;
	NSDate *birthDate;
	NSString *avatar;
	NSString *email;
}

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
//passwordHash	passwordHash
//Type: string
//Multiple: false

@end
