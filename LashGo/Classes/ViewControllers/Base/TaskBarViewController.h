//
//  TaskBarViewController.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 25.08.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "TitleBarViewController.h"
#import "TaskbarManager.h"

@interface TaskBarViewController : TitleBarViewController

@property (nonatomic, readonly) TaskbarContentType taskbarContentType;

@end
