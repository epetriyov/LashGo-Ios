//
//  PhotoViewController.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 05.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "TitleBarViewController.h"

#import "LGCheck.h"

@interface PhotoViewController : TitleBarViewController

@property (nonatomic, strong) LGCheck *check;
@property (nonatomic, strong) NSString *photoURL;

@end
