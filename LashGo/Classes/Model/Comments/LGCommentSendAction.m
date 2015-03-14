//
//  LGCommentSendAction.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.03.15.
//  Copyright (c) 2015 Vitaliy Pykhtin. All rights reserved.
//

#import "LGCommentSendAction.h"

@implementation LGCommentSendAction

- (NSDictionary *) JSONObject {
	return @{@"comment": self.comment};
}

@end
