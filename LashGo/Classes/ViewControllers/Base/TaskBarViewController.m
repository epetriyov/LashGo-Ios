//
//  TaskBarViewController.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 25.08.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "TaskBarViewController.h"
#import "AuthorizationManager.h"

@interface TaskBarViewController ()

@end

@implementation TaskBarViewController

@dynamic taskbarContentType;

- (TaskbarContentType) taskbarContentType {
	return TaskbarContentTypeLight;
}

- (CGRect) contentFrame {
	CGRect titleBarViewControllerRect = [super contentFrame];
	titleBarViewControllerRect.size.height -= [TaskbarManager sharedManager].taskbarHeight;
	return titleBarViewControllerRect;
}

- (void) viewWillAppear: (BOOL) animated {
	[super viewWillAppear: animated];
	
	NSArray *buttonsArray;
	
	if ([AuthorizationManager sharedManager].account != nil) {
		buttonsArray = @[@(TaskbarButtonTypeTask),
						 @(TaskbarButtonTypeFollow),
						 @(TaskbarButtonTypeNews),
						 @(TaskbarButtonTypeProfile),
						 @(TaskbarButtonTypeMore)];
	} else {
		buttonsArray = @[@(TaskbarButtonTypeTask),
// 						 @(TaskbarButtonTypeNews),
						 @(TaskbarButtonTypeMore)];
	}
	
	[ [TaskbarManager sharedManager] showTaskbarInView: self.view
									   withButtonTypes: buttonsArray
										   contentType: self.taskbarContentType];
}
@end
