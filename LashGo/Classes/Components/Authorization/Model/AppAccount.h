//
//  AppAccount.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 12.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(short, AppAccountType) {
	AppAccountTypeUnknown = 0,
	AppAccountTypeFacebook,
	AppAccountTypeTwitter,
	AppAccountTypeVkontakte
};

@protocol AppAccountDelegate;

@interface AppAccount : NSObject

@property (nonatomic, weak) id<AppAccountDelegate> delegate;
@property (nonatomic, readonly) AppAccountType accountType;
@property (nonatomic, readonly) NSString *accessToken;

- (void) login;
- (void) logout;

- (void) handleApplicationDidBecomeActive;
- (void) handleApplicationWillTerminate;
- (BOOL) handleOpenURL:(NSURL *)url
	 sourceApplication:(NSString *)sourceApplication;

@end

@protocol AppAccountDelegate <NSObject>

@required
- (void) authDidFinish: (BOOL) success forAccount: (AppAccount *) account;

@end
