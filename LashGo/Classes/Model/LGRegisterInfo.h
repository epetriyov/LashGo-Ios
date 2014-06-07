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

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *surname;
@property (nonatomic, strong) NSString *about;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *birthDate;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *passwordHash;

@end
