//
//  DataProvider.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGLoginInfo.h"
#import "LGRecoverInfo.h"
#import "LGRegisterInfo.h"
#import "LGSocialInfo.h"

@protocol DataProviderDelegate;

@interface DataProvider : NSObject

@property (nonatomic, weak) id<DataProviderDelegate> delegate;

- (void) checks;
- (void) checkCurrent;
- (void) checkAddCommentFor: (int64_t) checkID;//Not finished
- (void) checkCommentsFor: (int64_t) checkID;
//- (void) checkAddPhoto
- (void) checkPhotosFor: (int64_t) checkID;
- (void) checkVotePhotosFor: (int64_t) checkID;

- (void) commentRemove: (int64_t) commentID;

//- (void) photo: (NSString *) name;
- (void) photoCommentsFor: (int64_t) photoID;
//- (void) photoAddCommentFor: (int64_t) photoID;
- (void) photoVoteFor: (int64_t) photoID;

- (void) userLogin: (LGLoginInfo *) inputData;
- (void) userMainScreenInfo;
- (void) userPhotos;
- (void) userPhotosFor: (int32_t) userID;
- (void) userProfile;
- (void) userRecover: (LGRecoverInfo *) inputData;
- (void) userRegister: (LGLoginInfo *) inputData;
- (void) userSocialSignIn: (LGSocialInfo *) inputData;
- (void) userSocialSignUp: (LGSocialInfo *) inputData;
- (void) userSubscribeTo: (int32_t) userID;
- (void) userSubscriptions;
- (void) userUnsubscribeFrom: (int32_t) userID;

@end

@protocol DataProviderDelegate <NSObject>

@optional
- (void) dataProvider: (DataProvider *) dataProvider didGetChecks: (NSArray *) checks;
- (void) dataProvider: (DataProvider *) dataProvider didGetCheckVotePhotos: (NSArray *) votePhotos;

- (void) dataProvider: (DataProvider *) dataProvider didGetUserPhotos: (NSArray *) photos;

- (void) dataProviderDidRecoverPass: (DataProvider *) dataProvider;
- (void) dataProvider: (DataProvider *) dataProvider didRegisterUser: (LGRegisterInfo *) registerInfo;
- (void) dataProvider: (DataProvider *) dataProvider didFailRegisterUserWith: (NSError *) error;

@end
