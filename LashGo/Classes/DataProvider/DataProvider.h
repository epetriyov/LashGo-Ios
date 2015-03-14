//
//  DataProvider.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "JSONParser.h"

#import "ContextualArrayResult.h"
//#import "LGCheck.h"
#import "LGCommentSendAction.h"
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

- (void) apnsRegisterWithToken: (NSString *) inputData;

- (void) checksWithContext: (id) context;
- (void) checksSearch: (NSString *) inputData;
- (void) checkFor: (LGCheck *) inputData;
- (void) checkCurrent;
- (void) checkAddCommentFor: (LGCommentSendAction *) inputData;
- (void) checkCommentsFor: (int64_t) checkID;
- (void) checkAddPhoto: (LGCheck *) inputData;
- (void) checkPhotosFor: (int64_t) checkID;
- (void) checkVotePhotosFor: (int64_t) checkID;
- (void) checkUsersFor: (LGCheck *) inputData;

- (void) commentRemove: (int64_t) commentID;

- (void) events;
- (void) news;

//- (void) photo: (NSString *) name;
- (void) photoCommentsFor: (LGPhoto *) inputData;
- (void) photoAddCommentFor: (LGCommentSendAction *) inputData;
- (void) photoComplainFor:(LGPhoto *)inputData;
- (void) photoCountersFor: (LGPhoto *) inputData;
- (void) photoVotesFor: (LGPhoto *) inputData;
- (void) photoVote: (LGVoteAction *) inputData;

- (void) usersSearch: (NSString *) inputData;
- (void) userAvatarUpdateWith: (NSData *) inputData;
- (void) userLogin: (LGLoginInfo *) inputData;
- (void) userMainScreenInfo;
- (void) userPhotos;
- (void) userPhotosFor: (int32_t) userID;
- (void) userProfile;
- (void) userProfileFor: (int32_t) userID;
- (void) userProfileUpdateWith: (LGUser *) inputData;
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
- (void) dataProvider: (DataProvider *) dataProvider didGetChecks: (ContextualArrayResult *) checks;
- (void) dataProvider: (DataProvider *) dataProvider didGetChecksSearch: (NSArray *) checks;
- (void) dataProvider: (DataProvider *) dataProvider didGetCheckPhotos: (NSArray *) photos;
- (void) dataProvider: (DataProvider *) dataProvider didGetCheckVotePhotos: (LGVotePhotosResult *) votePhotos;

- (void) dataProvider: (DataProvider *) dataProvider didGetComments: (ContextualArrayResult *) comments;
- (void) dataProvider: (DataProvider *) dataProvider didGetVotes: (ContextualArrayResult *) votes;

- (void) dataProvider: (DataProvider *) dataProvider didGetEvents: (NSArray *) events;
- (void) dataProvider: (DataProvider *) dataProvider didGetNews: (NSArray *) news;

- (void) dataProvider: (DataProvider *) dataProvider didGetSubscriptions: (LGSubscriptionsResult *) subscriptions;

- (void) dataProvider: (DataProvider *) dataProvider didPhotoVote: (LGVoteAction *) voteAction;
- (void) dataProvider: (DataProvider *) dataProvider didGetPhotoWithCounters: (LGPhoto *) photo;

- (void) dataProvider: (DataProvider *) dataProvider didGetUsersSearch: (NSArray *) users;
- (void) dataProviderDidUserAvatarUpdate: (DataProvider *) dataProvider;
- (void) dataProviderDidFailUserAvatarUpdate: (DataProvider *) dataProvider;
- (void) dataProvider: (DataProvider *) dataProvider didGetUserPhotos: (NSArray *) photos;
- (void) dataProvider: (DataProvider *) dataProvider didGetUserProfile: (LGUser *) user;
- (void) dataProvider: (DataProvider *) dataProvider didUserProfileUpdate: (LGUser *) user;
- (void) dataProvider: (DataProvider *) dataProvider didUserSubscribeTo: (LGSubscribe *) subscribe;
- (void) dataProvider: (DataProvider *) dataProvider didUserUnsubscribeFrom: (LGSubscribe *) subscribe;

- (void) dataProviderDidRecoverPass: (DataProvider *) dataProvider;
- (void) dataProvider: (DataProvider *) dataProvider didRegisterUser: (LGRegisterInfo *) registerInfo;
- (void) dataProvider: (DataProvider *) dataProvider didFailRegisterUserWith: (NSError *) error;

@end
