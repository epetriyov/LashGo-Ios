//
//  SearchViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 21.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "SearchViewController.h"

#import "Common.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void) loadView {
	[super loadView];
	
	[titleBarView removeFromSuperview];
	titleBarView = [TitleBarView titleBarViewWithSearchAndRightButtonWithText: @"Отмена".commonLocalizedString];
	[titleBarView.rightButton addTarget: self action: @selector(backAction:)
					   forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: titleBarView];
}

@end
