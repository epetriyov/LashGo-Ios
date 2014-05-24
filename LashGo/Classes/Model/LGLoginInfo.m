//
//  LGLoginInfo.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGLoginInfo.h"

@implementation LGLoginInfo

@synthesize login, passwordHash;

- (void) dealloc {
	[login release];
	[passwordHash release];
	
	[super dealloc];
}

@end
