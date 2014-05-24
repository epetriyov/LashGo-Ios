//
//  DataProvider.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "DataProvider.h"

#define kWebServiceURL @"http://90.188.31.70:8080/lashgo-api"

#define kUsersLoginPath		@"/users/login" //POST
#define kUsersPhotosPath	@"/users/photos" //GET
#define kUsersProfilePath	@"/users/profile" //GET
#define kUsersRecoverPath	@"/users/recover" //PUT
#define kUsersRegisterPath	@"/users/register" //POST
#define kUsersSubscriptionsPath			@"/users/subscriptions" //GET
#define kUsersSubscriptionsManagePath	@"/users/subscriptions/%d" //DELETE, POST

@implementation DataProvider

@end
