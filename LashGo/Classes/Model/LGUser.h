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
@property (nonatomic, retain) NSString *login;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *surname;
@property (nonatomic, retain) NSString *about;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSDate *birthDate;
@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, retain) NSString *email;

@end
