//
//  LGPhoto.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGCheck.h"
#import "LGUser.h"

@interface LGPhoto : NSObject {
	int64_t uid;
	NSString *url;
	LGCheck *check;
	LGUser *user;
}

@property (nonatomic, assign) int64_t uid;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) LGCheck *check;
@property (nonatomic, strong) LGUser *user;

@property (nonatomic, assign) BOOL isBanned;
@property (nonatomic, assign) BOOL isWinner;

@end
