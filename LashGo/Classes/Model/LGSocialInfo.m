//
//  LGSocialInfo.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 04.08.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGSocialInfo.h"
#import "Common.h"

@implementation LGSocialInfo

- (NSDictionary *) JSONObject {
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   self.accessToken, @"accessToken", nil];
	if ([Common isEmptyString: self.accessTokenSecret] == NO) {
		result[@"accessTokenSecret"] = self.accessTokenSecret;
	}
	if ([Common isEmptyString: self.socialName] == NO) {
		result[@"socialName"] = self.socialName;
	}
	return result;
}

@end
