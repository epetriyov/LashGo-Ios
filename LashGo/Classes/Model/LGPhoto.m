//
//  LGPhoto.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGPhoto.h"

@implementation LGPhoto

@synthesize uid, url, rating, check, user;

- (void) dealloc {
	[url release];
	[check release];
	[user release];
	
	[super dealloc];
}

@end