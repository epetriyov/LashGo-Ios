//
//  DataProvider.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "JSONParser.h"

//#import "LGCheck.h"
#import "LGLoginInfo.h"
#import "LGRecoverInfo.h"
//#import "LGRegisterInfo.h"
#import "LGSocialInfo.h"
#import "LGSubscribe.h"
#import "LGSubscriptionsResult.h"
#import "LGVoteAction.h"

@protocol DataProviderDelegate;

@interface DataProvider : NSObject

@property (nonatomic, weak) id<DataProviderDelegate> delegate;

- (void) checks;
- (void) checkFor: (LGCheck *) inputData;
- (void) checkCurrent;
- (void) checkAddCommentFor: (int64_t) checkID;//Not finished
- (void) checkCommentsFor: (int64_t) checkID;
- (void) checkAddPhoto: (LGCheck *) inputData;
- (void) checkPhotosFor: (int64_t) checkID;
- (void) checkVotePhotosFor: (int64_t) checkID;
- (void) checkUsersFor: (LGCheck *) inputData;

- (void) commentRemove: (int64_t) commentID;

- (void) events;

//- (void) photo: (NSString *) name;
- (void) photoCommentsFor: (int64_t) photoID;
//- (void) photoAddCommentFor: (int64_t) photoID;
- (void) photoVote: (LGVoteAction *) inputData;

- (void) userLogin: (LGLoginInfo *) inputData;
- (void) userMainScreenInfo;
- (void) userPhotos;
- (void) userPhotosFor: (int32_t) userID;
- (void) userProfile;
- (void) userProfileFor: (int32_t) userID;
- (void) userRecover: (LGRecoverInfo *) inputData;
- (void) userRegister: (LGLoginInfo *) inputData;
- (void) userSocialSignIn: (LGSocialInfo *) inputData;
- (void) userSubscribersFor: (LGUser *) inputData;
- (void) userSubscribtionsFor: (LGUser *) inputData;
- (void) userSubscribeTo: (LGSubscribe *) inputData;
- (void) userUnsubscribeFrom: (LGSubscribe *) inputData;

@end

@protocol DataProviderDelegate <NSObject>

@optional
- (void) dataProvider: (DataProvider *) dataProvider didGetChecks: (NSArray *) checks;
- (void) dataProvider: (DataProvider *) dataProvider didGetCheckPhotos: (NSArray *) photos;
- (void) dataProvider: (DataProvider *) dataProvider didGetCheckVotePhotos: (LGVotePhotosResult *) votePhotos;

- (void) dataProvider: (DataProvider *) dataProvider didGetSubscriptions: (LGSubscriptionsResult *) subscriptions;

- (void) dataProvider: (DataProvider *) dataProvider didPhotoVote: (LGVoteAction *) voteAction;

- (void) dataProvider: (DataProvider *) dataProvider didGetUserPhotos: (NSArray *) photos;
- (void) dataProvider: (DataProvider *) dataProvider didGetUserProfile: (LGUser *) user;
- (void) dataProvider: (DataProvider *) dataProvider didUserSubscribeTo: (LGSubscribe *) subscribe;
- (void) dataProvider: (DataProvider *) dataProvider didUserUnsubscribeFrom: (LGSubscribe *) subscribe;

- (void) dataProviderDidRecoverPass: (DataProvider *) dataProvider;
- (void) dataProvider: (DataProvider *) dataProvider didRegisterUser: (LGRegisterInfo *) registerInfo;
- (void) dataProvider: (DataProvider *) dataProvider didFailRegisterUserWith: (NSError *) error;

@end
