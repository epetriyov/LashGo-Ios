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
	NSString *name;
	NSString *surname;
	NSString *about;
	NSString *city;
	NSDate *birthDate;
	NSString *avatar;
	NSString *email;
}

@property (nonatomic, assign) int32_t uid;
@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *surname;
@property (nonatomic, strong) NSString *about;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSDate *birthDate;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *email;

@end
