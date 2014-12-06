//
//  SubscriptionViewController.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 29.11.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "TitleBarViewController.h"

#import "LGCheck.h"

typedef NS_ENUM(ushort, SubscriptionViewControllerMode) {
	SubscriptionViewControllerModeCheckUsers = 0,
	SubscriptionViewControllerModeUserSubscribers,
	SubscriptionViewControllerModeUserSubscribtions
};

@interface SubscriptionViewController : TitleBarViewController

@property (nonatomic, strong) LGCheck *check;
@property (nonatomic, strong) LGUser *user;
@property (nonatomic, assign) SubscriptionViewControllerMode mode;

@end
