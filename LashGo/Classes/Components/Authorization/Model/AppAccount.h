//
//  AppAccount.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 12.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGUser.h"
#import "DataProvider.h"

typedef NS_ENUM(short, AppAccountType) {
	AppAccountTypeUnknown = 0,
	AppAccountTypeFacebook,
	AppAccountTypeLashGo,
	AppAccountTypeTwitter,
	AppAccountTypeVkontakte
};

@protocol AppAccountDelegate;

@interface AppAccount : NSObject {
	DataProvider *_dataProvider;
}

@property (nonatomic, weak) id<AppAccountDelegate> delegate;
@property (nonatomic, readonly) NSString *accountSocialName;
@property (nonatomic, readonly) AppAccountType accountType;
@property (nonatomic, readonly) NSString *accessToken;

@property (nonatomic, strong) NSString *sessionID;
@property (nonatomic, strong) LGUser *userInfo;

- (void) login;
- (void) logout;

- (void) handleApplicationDidBecomeActive;
- (void) handleApplicationWillTerminate;
- (BOOL) handleOpenURL:(NSURL *)url
	 sourceApplication:(NSString *)sourceApplication;

- (void) cleanDataAsync;
- (void) storeDataAsync;

@end

@protocol AppAccountDelegate <NSObject>

@required
- (void) authDidFinish: (BOOL) success forAccount: (AppAccount *) account;

@end
