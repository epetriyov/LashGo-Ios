//
//  LashGoAppAccount.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 13.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "AppAccount.h"
#import "LGLoginInfo.h"

@interface LashGoAppAccount : AppAccount

@property (nonatomic, strong) LGLoginInfo *loginInfo;

- (void) registerAccount;

@end
