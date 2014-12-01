//
//  LGSubscribe.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 30.11.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGSubscribe.h"

@implementation LGSubscribe

#pragma mark JSONSerializableProtocol implementation

- (NSDictionary *) JSONObject {
	return @{@"userId" : @(self.subscription.user.uid)};
}

@end
