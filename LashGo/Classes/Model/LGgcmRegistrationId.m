//
//  LGgcmRegistrationId.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGgcmRegistrationId.h"

@implementation LGgcmRegistrationId

@synthesize uid;

- (void) dealloc {
	[uid release];
	
	[super dealloc];
}

@end
