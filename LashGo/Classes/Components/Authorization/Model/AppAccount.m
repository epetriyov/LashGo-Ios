//
//  AppAccount.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 12.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "AppAccount.h"

@implementation AppAccount

@dynamic accessToken;

- (NSString *) accessToken {
	return nil;
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