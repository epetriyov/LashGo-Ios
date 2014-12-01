//
//  JSONParser.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGCheck.h"
#import "LGPhoto.h"
#import "LGRegisterInfo.h"
#import "LGSubscription.h"
#import "LGVotePhoto.h"
#import "LGVotePhotosResult.h"
#import "URLConnection.h"

@interface JSONParser : NSObject

- (id) parseJSONData: (NSData *) jsonData;
- (NSError *) parseError: (URLConnection *) connection;

- (LGCheck *) parseCheckData: (NSData *) jsonData;
- (NSArray *) parseChecks: (NSData *) jsonData;
- (NSArray *) parseCheckPhotos: (NSData *) jsonData;
- (NSArray *) parseCheckUsers: (NSData *) jsonData;
- (LGVotePhotosResult *) parseCheckVotePhotos: (NSData *) jsonData;
- (LGRegisterInfo *) parseRegiserInfo: (NSData *) jsonData;

- (NSArray *) parseUserPhotos: (NSData *) jsonData;
- (LGUser *) parseUserProfile: (NSData *) jsonData;

@end
