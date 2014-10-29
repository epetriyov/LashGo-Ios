//
//  VoteViewController.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 17.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "TitleBarViewController.h"
@class LGCheck;

@interface VoteViewController : TitleBarViewController

@property (nonatomic, strong) LGCheck *check;

- (void) voteFinished;

@end
