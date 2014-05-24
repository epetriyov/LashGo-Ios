//
//  LGContent.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGContent.h"

@implementation LGContent

@synthesize createDate, text;

- (void) dealloc {
	[createDate release];
	[text release];
	
	[super dealloc];
}

@end
