//
//  AppAccount.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 12.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(short, AppAccountType) {
	AppAccountTypeFacebook,
	AppAccountTypeTwitter,
	AppAccountTypeVkontakte
};

@interface AppAccount : NSObject {
}

@property (nonatomic, readonly) AppAccountType *accountType;
@property (nonatomic, readonly) NSString *accessToken;

- (void) handleApplicationDidBecomeActive;
- (void) handleApplicationWillTerminate;
- (BOOL) handleOpenURL:(NSURL *)url
	 sourceApplication:(NSString *)sourceApplication;

@end
