//
//  LGRecoverInfo.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGRecoverInfo.h"

@implementation LGRecoverInfo

- (NSDictionary *) JSONObject {
	return @{@"email": self.email};
}

@end
