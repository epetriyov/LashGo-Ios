//
//  SearchViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 21.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "SearchViewController.h"

#import "Common.h"

@interface SearchViewController () {
	SegmentedTextControl __weak *_segmentedControl;
}

@end

@implementation SearchViewController

- (void) loadView {
	[super loadView];
	
	[_titleBarView removeFromSuperview];
	_titleBarView = [TitleBarView titleBarViewWithRightButtonWithText: @"Отмена".commonLocalizedString
													   searchDelegate: self];
	[_titleBarView.rightButton addTarget: self action: @selector(backAction:)
					   forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: _titleBarView];
	
	float offsetY = self.contentFrame.origin.y;
	
	SegmentedTextControl *segmentedControl = [[SegmentedTextControl alloc] initWithButtonsTexts: @[@"SearchPeople".commonLocalizedString,
																								   @"SearchChecks".commonLocalizedString]
															buttonsBgName: @"sc_2button"
																   bgName: @"sc_bg"];
	segmentedControl.delegate = self;
	CGPoint segmentedControlCenter = segmentedControl.center;
	segmentedControlCenter.y += offsetY;
	segmentedControl.center = segmentedControlCenter;
	[self.view addSubview: segmentedControl];
	_segmentedControl = segmentedControl;
}

#pragma mark - SegmentedTextControlDelegate implementation

- (void) segmentedControl: (SegmentedTextControl *) segmentedControl selectedIndexChangedTo: (ushort) selectedIndex {
}

#pragma mark - UISearchBarDelegate implementation

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	
}

@end
