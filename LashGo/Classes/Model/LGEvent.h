//
//  LGEvent.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 09.12.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGCheck.h"
#import "LGPhoto.h"
#import "LGUser.h"

@interface LGEvent : NSObject

@property (nonatomic, assign) int64_t uid;
@property (nonatomic, strong) LGCheck *check;
@property (nonatomic, strong) LGUser *user;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSDate *eventDate;

//action	action's code of event
//Type: string
//Multiple: false
//eventDate	event date
//Type: date
//Multiple: false
//photoDto	photo info
//Type: photo
//Multiple: false
//objectUser	object user
//Type: user

@end
