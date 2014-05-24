//
//  LGRegisterInfo.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGRegisterInfo.h"

@implementation LGRegisterInfo

@synthesize name, surname, about, city, birthDate, avatar, email, login, passwordHash;

- (void) dealloc {
	[name release];
	[surname release];
	[about release];
	[city release];
	[birthDate release];
	[avatar release];
	[email release];
	[login release];
	[passwordHash release];
	
	[super dealloc];
}

@end
