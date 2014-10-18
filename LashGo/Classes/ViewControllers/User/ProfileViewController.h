//
//  ProfileViewController.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "TitleBarViewController.h"

#import "LGUser.h"

@interface ProfileViewController : TitleBarViewController

@property (nonatomic, strong) LGUser *user;
@property (nonatomic, strong) NSArray *photos;

@end
