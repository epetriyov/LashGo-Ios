#import "TitleBarViewController.h"
#import "Kernel.h"
#import "ViewFactory.h"

#define kAnimationDuration 0.3

@interface TitleBarViewController () {
	UIView *_waitView;
}

@property (nonatomic, readonly) CGRect waitViewFrame;

@end

@implementation TitleBarViewController

@dynamic contentFrame;
@dynamic canGoBack;
@dynamic waitViewFrame;
@dynamic waitViewHidden;

#pragma mark - Properties

- (CGRect) contentFrame {
	float offsetY = _titleBarView.frame.origin.y + _titleBarView.frame.size.height;
	return CGRectMake(0, offsetY, self.view.frame.size.width, self.view.frame.size.height - offsetY);
}

- (BOOL) canGoBack {
	return _titleBarView.backButton.hidden == NO && _titleBarView.backButton.alpha > 0;
}

- (void) setCanGoBack:(BOOL) value {
	if (value == YES) {
		_titleBarView.backButton.alpha = 1;
	} else {
		_titleBarView.backButton.alpha = 0;
	}
}

- (CGRect) waitViewFrame {
	return self.contentFrame;
}

- (BOOL) isWaitViewHidden {
	return _waitView != nil;
}

- (void) setWaitViewHidden:(BOOL)waitViewHidden {
	if (waitViewHidden == YES && _waitView != nil) {
		[UIView animateWithDuration: kAnimationDuration animations:^{
			_waitView.alpha = 0;
		} completion:^(BOOL finished) {
			[_waitView removeFromSuperview];
			_waitView = nil;
		}];
	} else if (waitViewHidden == NO && _waitView == nil) {
		_waitView = [[UIView alloc] initWithFrame: self.waitViewFrame];
		_waitView.alpha = 0;
		
		UIView *waitBgView = [[UIView alloc] initWithFrame: _waitView.bounds];
		waitBgView.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0.7];
		[_waitView addSubview: waitBgView];
		
		UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
		activityIndicatorView.center = waitBgView.center;
		[activityIndicatorView startAnimating];
		[_waitView addSubview: activityIndicatorView];
		
		[self.view addSubview: _waitView];
		[UIView animateWithDuration: kAnimationDuration animations:^{
			_waitView.alpha = 1;
		}];
	}
}

#pragma mark - Overrides

- (void) loadView {
	[super loadView];
	
	TitleBarView *tbView = [TitleBarView titleBarView];
	[tbView.backButton addTarget: self action: @selector(backAction:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: tbView];
	_titleBarView = tbView;
	
//	if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
////		work only if navigationBarHidden == NO
////		self.edgesForExtendedLayout = UIRectEdgeNone;
//		UIView *statusBarBgView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 20)];
//		statusBarBgView.backgroundColor = [ViewFactory sharedFactory].statusBarPreferredColor;
//		[self.view addSubview: statusBarBgView];
//		
//		[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent animated: NO];
//    }
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
	if (kernel.viewControllersManager.isReturnToPreviousAvaliable == YES) {
		_titleBarView.backButton.hidden = NO;
	} else {
		_titleBarView.backButton.hidden = YES;
	}
}

#pragma mark - Methods

- (void) backAction: (id) sender {
    [kernel.viewControllersManager returnToPreviousViewController];
}

@end
