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
	int32_t rating;
	LGCheck *check;
	LGUser *user;
}

@property (nonatomic, assign) int64_t uid;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, assign) int32_t rating;
@property (nonatomic, retain) LGCheck *check;
@property (nonatomic, retain) LGUser *user;

@end
