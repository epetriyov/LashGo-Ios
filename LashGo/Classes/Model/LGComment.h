//
//  LGComment.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGUser.h"

@interface LGComment : NSObject {
	int64_t uid;
	NSString *content;
	NSDate *createDate;
	LGUser *user;
}

@property (nonatomic, assign) int64_t uid;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSDate *createDate;
@property (nonatomic, retain) LGUser *user;

@end
