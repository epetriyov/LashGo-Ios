//
//  AuthorizationManager.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 12.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppAccount.h"

@interface AuthorizationManager : NSObject {
	AppAccount *_account;
}

@property (nonatomic, readonly) AppAccount *account;

+ (instancetype) sharedManager;

- (void) loginUsingFacebook;

@end
