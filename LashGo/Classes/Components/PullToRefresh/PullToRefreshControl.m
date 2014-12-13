//
//  PullToRefreshControl.m
//  SmartKeeper
//
//  Created by Vitaliy Pykhtin on 03.10.14.
//  Copyright (c) 2014 Soft-logic LLC. All rights reserved.
//

#import "PullToRefreshControl.h"

#import "Common.h"
#import "FontFactory.h"

#define kAnimationDuration 0.3

@interface PullToRefreshControl () {
	UIActivityIndicatorView *refreshIndicator;
	UILabel *_textLabel;
	NSString *_pullText;
	NSString *_releaseText;
}

@end

@implementation PullToRefreshControl

@dynamic isActive;

- (BOOL) isActive {
	return refreshIndicator.isAnimating;
}

- (void) setMode:(PullToRefreshControlMode)mode {
	if (_mode != mode) {
		_mode = mode;
		if (mode == PullToRefreshControlModeToBottom) {
			_textLabel.frame = _textLabel.bounds;
			_pullText = [@"PullToRefreshPullToFetchMoreText".commonLocalizedString retain];
		} else {
			_textLabel.frame = CGRectOffset(_textLabel.bounds, 0, self.frame.size.height - _textLabel.frame.size.height);
			_pullText = @"PullToRefreshPullToRefreshText".commonLocalizedString;
		}
	}
}

#pragma mark - Overrides

- (instancetype) initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame: frame]) {
		refreshIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
		refreshIndicator.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
		[self addSubview: refreshIndicator];
		[refreshIndicator release];
		
		_pullText = [@"PullToRefreshPullToRefreshText".commonLocalizedString retain];
		_releaseText = [@"PullToRefreshReleaseText".commonLocalizedString retain];
		
		float labelHeight = 16;
		_textLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, frame.size.height - labelHeight,
																frame.size.width, labelHeight)];
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.alpha = 0;
		_textLabel.font = [FontFactory fontWithType: FontTypePullToRefreshTitle];
		_textLabel.text = _pullText;
		_textLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview: _textLabel];
		[_textLabel release];
	}
	return self;
}

- (void) dealloc {
	[_pullText release];
	[_releaseText release];
	
	[super dealloc];
}

- (void) setActive: (BOOL) active forScrollView: (UIScrollView *) containingScrollView {
	if (self.isActive == active) {
		return;
	}
	
	if (active == YES) {
		UIEdgeInsets insets;
		if (self.mode == PullToRefreshControlModeToTop) {
			insets = UIEdgeInsetsMake(- self.frame.origin.y, 0, 0, 0);
		} else {
			insets = UIEdgeInsetsMake(0, 0, self.frame.size.height, 0);
		}
		
		[refreshIndicator startAnimating];
		[UIView animateWithDuration: kAnimationDuration animations: ^ {
			containingScrollView.contentInset = insets;
		}];
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	} else {
		[refreshIndicator stopAnimating];
		[UIView animateWithDuration: kAnimationDuration animations: ^ {
			containingScrollView.contentInset = UIEdgeInsetsZero;
		}];
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

- (void)containingScrollViewWillBeginDragging: (UIScrollView *) containingScrollView {
	if (self.mode == PullToRefreshControlModeToBottom) {
		self.frame = CGRectOffset(self.bounds, 0, containingScrollView.contentSize.height);
	}
}

- (void)containingScrollViewDidScroll: (UIScrollView *) containingScrollView {
	//actions only when user interact with scroll
	if (containingScrollView.tracking == NO || self.isActive == YES) {
		return;
	}
	
	BOOL shouldDisplayLabel = NO;
	if (self.mode == PullToRefreshControlModeToTop) {
		shouldDisplayLabel = containingScrollView.contentOffset.y < 0;
		_isActivationCharged = containingScrollView.contentOffset.y <= self.frame.origin.y;
	} else if (self.mode == PullToRefreshControlModeToBottom) {
		shouldDisplayLabel = containingScrollView.contentOffset.y > containingScrollView.contentSize.height - containingScrollView.frame.size.height;
		_isActivationCharged = containingScrollView.contentOffset.y > (containingScrollView.contentSize.height - containingScrollView.frame.size.height) + self.frame.size.height;
	}
	
	if (shouldDisplayLabel == YES) {
		if (_textLabel.alpha < 1) {
			[UIView animateWithDuration: kAnimationDuration animations:^{
				_textLabel.alpha = 1;
			}];
		}
	}
	
	if (self.isActivationCharged == YES) {
		_textLabel.text = _releaseText;
	} else if (self.isActive == NO) {
		//check for activity to prevent flickering text when user release scroll
		_textLabel.text = _pullText;
	}
}

///This instead of DidEndDragging because of flickering at ios 8 
- (void)containingScrollViewWillBeginDecelerating:(UIScrollView *)containingScrollView {
	if (self.isActivationCharged == YES) {
		_isActivationCharged = NO;
		[self setActive: YES forScrollView: containingScrollView];
	}
	if (_textLabel.alpha > 0) {
		[UIView animateWithDuration: kAnimationDuration animations: ^ {
			_textLabel.alpha = 0;
		}];
	}
}

@end
