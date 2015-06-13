//
//  Storage.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 07.08.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGUser.h"
#import "LGVotePhotosResult.h"

extern NSString *const kLGStorageChecksActionObservationPath;
extern NSString *const kLGStorageChecksSelfieObservationPath;

@interface Storage : NSObject

@property (nonatomic, strong) NSArray *checks;
@property (nonatomic, readonly) NSArray *checksActions;
@property (nonatomic, readonly) NSArray *checksSelfie;
@property (nonatomic, strong) NSArray *checkPhotos;
@property (nonatomic, strong) LGVotePhotosResult *checkVotePhotos;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSArray *news;
@property (nonatomic, strong) LGUser *lastViewProfileDetail;
@property (nonatomic, strong) NSArray *searchChecks;
@property (nonatomic, strong) NSArray *searchUsers;

@end
