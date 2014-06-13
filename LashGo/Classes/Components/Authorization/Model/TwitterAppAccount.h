//
//  TwitterAppAccount.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 13.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "AppAccount.h"
#import <Accounts/Accounts.h>

@interface TwitterAppAccount : AppAccount {
	ACAccountStore __strong *_accountStore;
	ACAccount __strong *_account;
}

@end
