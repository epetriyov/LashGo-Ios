//
//  LGUser.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGUser.h"

@implementation LGUser

@synthesize uid, login, fio, about, city, birthDate, avatar, email;

- (NSString *) fio {
	if (fio == nil) {
		return login;
	}
	return fio;
}

#pragma mark - NSCoding protocol implementation

-(void) encodeWithCoder: (NSCoder*) coder {
	[coder encodeInt32: self.uid forKey: @"uid"];
	[coder encodeObject: self.login forKey: @"login"];
	[coder encodeObject: self.fio forKey: @"fio"];
	[coder encodeObject: self.about forKey: @"about"];
	[coder encodeObject: self.city forKey: @"city"];
	//date NSDate
	[coder encodeObject: self.avatar forKey: @"avatar"];
	[coder encodeObject: self.email forKey: @"email"];
	
	[coder encodeInt32: self.userSubscribes forKey: @"userSubscribes"];
	[coder encodeInt32: self.userSubscribers forKey: @"userSubscribers"];
	[coder encodeInt32: self.checksCount forKey: @"checksCount"];
	[coder encodeInt32: self.commentsCount forKey: @"commentsCount"];
	[coder encodeInt32: self.likesCount forKey: @"likesCount"];
}

-(id) initWithCoder: (NSCoder*) coder {
	if (self = [super init]) {
		self.uid =			[coder decodeInt32ForKey: @"uid"];
		self.login =		[coder decodeObjectForKey: @"login"];
		self.fio =			[coder decodeObjectForKey: @"fio"];
		self.about =		[coder decodeObjectForKey: @"about"];
		self.city =			[coder decodeObjectForKey: @"city"];
		//date
		self.avatar =		[coder decodeObjectForKey: @"avatar"];
		self.email =		[coder decodeObjectForKey: @"email"];
		
		self.userSubscribes =	[coder decodeInt32ForKey: @"userSubscribes"];
		self.userSubscribers =	[coder decodeInt32ForKey: @"userSubscribers"];
		self.checksCount =		[coder decodeInt32ForKey: @"checksCount"];
		self.commentsCount =	[coder decodeInt32ForKey: @"commentsCount"];
		self.likesCount =		[coder decodeInt32ForKey: @"likesCount"];
	}
	return self;
}

@end
