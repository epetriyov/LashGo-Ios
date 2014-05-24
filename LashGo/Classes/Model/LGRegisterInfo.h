//
//  LGRegisterInfo.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGRegisterInfo : NSObject {
	NSString *name;
	NSString *surname;
	NSString *about;
	NSString *city;
	NSString *birthDate;
	NSString *avatar;
	NSString *email;
	NSString *login;
	NSString *passwordHash;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *surname;
@property (nonatomic, retain) NSString *about;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *birthDate;
@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *login;
@property (nonatomic, retain) NSString *passwordHash;

@end
