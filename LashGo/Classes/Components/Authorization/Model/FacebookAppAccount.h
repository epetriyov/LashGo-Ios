//
//  FacebookAppAccount.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 12.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "AppAccount.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookAppAccount : AppAccount {
	FBSession __strong *_session;
}

@end
