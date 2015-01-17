//
//  VkontakteAppAccount.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 16.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "AppAccount.h"
#import "VKSdk.h"

@interface VkontakteAppAccount : AppAccount <VKSdkDelegate>

@property (nonatomic, weak) UIViewController *presentingViewController;

@end
