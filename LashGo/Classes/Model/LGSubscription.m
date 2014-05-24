//
//  LGSubscription.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGSubscription.h"

@implementation LGSubscription

@synthesize uid, userUID, userAvatarURL, userLogin;

- (void) dealloc {
	[userAvatarURL release];
	[userLogin release];
	
	[super dealloc];
}

@end
