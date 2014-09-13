//
//  AuthorizationManager.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 12.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppAccount.h"
#import "LGLoginInfo.h"

extern NSString *const kAuthorizationNotification;

@interface AuthorizationManager : NSObject <AppAccountDelegate> {
	AppAccount *_account;
}

@property (nonatomic, readonly) AppAccount *account;

+ (instancetype) sharedManager;

- (void) loginUsingFacebook;
- (void) loginUsingLashGo: (LGLoginInfo *) loginInfo;
- (void) loginUsingTwitterFromView: (UIView *) loginView;
- (void) loginUsingVkontakte;

- (void) registerUsingLashGo: (LGLoginInfo *) loginInfo;

@end
