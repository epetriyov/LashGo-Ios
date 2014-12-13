//
//  PullToRefreshControl.h
//  SmartKeeper
//
//  Created by Vitaliy Pykhtin on 03.10.14.
//  Copyright (c) 2014 Soft-logic LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(ushort, PullToRefreshControlMode) {
	PullToRefreshControlModeToTop,
	PullToRefreshControlModeToBottom,
};

@interface PullToRefreshControl : UIControl

@property (nonatomic, readonly) BOOL isActive;
@property (nonatomic, readonly) BOOL isActivationCharged;
///By default, PullToRefreshControlModeToTop
@property (nonatomic, assign) PullToRefreshControlMode mode;

- (void) setActive: (BOOL) active forScrollView: (UIScrollView *) containingScrollView;

///Required for PullToRefreshControlModeToBottom to update frame
- (void)containingScrollViewWillBeginDragging: (UIScrollView *) containingScrollView;
- (void)containingScrollViewDidScroll: (UIScrollView *) containingScrollView;
- (void)containingScrollViewWillBeginDecelerating:(UIScrollView *)containingScrollView;

@end
