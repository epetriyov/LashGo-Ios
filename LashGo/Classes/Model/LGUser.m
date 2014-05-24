//
//  LGUser.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGUser.h"

@implementation LGUser

@synthesize uid, login, name, surname, about, city, birthDate, avatar, email;

- (void) dealloc {
	[login release];
	[name release];
	[surname release];
	[about release];
	[city release];
	[birthDate release];
	[avatar release];
	[email release];
	
	[super dealloc];
}

@end
