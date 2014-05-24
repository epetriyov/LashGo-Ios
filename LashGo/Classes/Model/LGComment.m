//
//  LGComment.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGComment.h"

@implementation LGComment

@synthesize uid, content, createDate, user;

- (void) dealloc {
	[content release];
	[createDate release];
	[user release];
	
	[super dealloc];
}

@end
