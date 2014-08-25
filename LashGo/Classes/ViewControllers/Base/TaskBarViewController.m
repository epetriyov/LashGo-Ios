//
//  TaskBarViewController.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 25.08.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "TaskBarViewController.h"

#import "TaskbarManager.h"

@interface TaskBarViewController ()

@end

@implementation TaskBarViewController

- (CGRect) contentFrame {
	CGRect titleBarViewControllerRect = [super contentFrame];
	titleBarViewControllerRect.size.height -= [TaskbarManager sharedManager].taskbarHeight;
	return titleBarViewControllerRect;
}

- (void) viewWillAppear: (BOOL) animated {
	[super viewWillAppear: animated];
	
	[ [TaskbarManager sharedManager] showTaskbarInView: self.view
									   withButtonTypes: @[@(TaskbarButtonTypeTask),
														  @(TaskbarButtonTypeFollow),
														  @(TaskbarButtonTypeNews),
														  @(TaskbarButtonTypeProfile),
														  @(TaskbarButtonTypeMore)]];
}
@end
