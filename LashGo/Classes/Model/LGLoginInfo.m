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

#pragma mark JSONSerializableProtocol implementation

- (NSDictionary *) JSONObject {
	return @{@"login" :			login,
			 @"passwordHash" :	passwordHash};
}

#pragma mark - NSCoding protocol implementation

-(void) encodeWithCoder: (NSCoder*) coder {
	[coder encodeObject: self.login forKey: @"login"];
	[coder encodeObject: self.passwordHash forKey: @"passwordHash"];
}

-(id) initWithCoder: (NSCoder*) coder {
	if (self = [super init]) {
		self.login =		[coder decodeObjectForKey: @"login"];
		self.passwordHash =	[coder decodeObjectForKey: @"passwordHash"];
	}
	return self;
}

@end
