//
//  AppAccount.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 12.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "AppAccount.h"

NSString *const kLastUsedSessionId = @"lg_last_used_session_id";

@implementation AppAccount

@dynamic accountSocialName;
@dynamic accountType;
@dynamic accessToken;

- (NSString *) accessToken {
	return nil;
}

#pragma mark - Properties

- (void) setSessionID:(NSString *)sessionID {
	_sessionID = sessionID;
	
	if (sessionID == nil) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey: kLastUsedSessionId];
	} else {
		[[NSUserDefaults standardUserDefaults] setObject: sessionID forKey: kLastUsedSessionId];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) login {
	
}

- (void) logout {
	
}

- (void) handleApplicationDidBecomeActive {
	
}

- (void) handleApplicationWillTerminate {
	
}

- (BOOL) handleOpenURL:(NSURL *)url
	 sourceApplication:(NSString *)sourceApplication {
	return NO;
}

@end
