//
//  DataProvider.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGLoginInfo.h"
#import "LGRecoverInfo.h"
#import "LGSocialInfo.h"

@interface DataProvider : NSObject

- (void) userLogin: (LGLoginInfo *) inputData;
- (void) userMainScreenInfo;
- (void) userPhotos;
- (void) userProfile;
- (void) userRecover: (LGRecoverInfo *) inputData;
- (void) userRegister: (LGLoginInfo *) inputData;
- (void) userSocialSignIn: (LGSocialInfo *) inputData;
- (void) userSocialSignUp: (LGSocialInfo *) inputData;
- (void) userSubscribeTo: (int32_t) userID;
- (void) userSubscriptions;
- (void) userUnsubscribeFrom: (int32_t) userID;

@end
