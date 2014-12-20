//
//  PhotoViewController.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 05.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "TitleBarViewController.h"

#import "LGCheck.h"

typedef NS_ENUM(ushort, CheckDetailViewMode) {
	CheckDetailViewModeAdminPhoto = 0,
	CheckDetailViewModeUserPhoto = 1,
	CheckDetailViewModeWinnerPhoto
};

@interface CheckDetailViewController : TitleBarViewController

@property (nonatomic, strong) LGCheck *check;
@property (nonatomic, strong) LGPhoto *photo;
@property (nonatomic, assign) CheckDetailViewMode mode;

- (void) refreshCounters;

@end
