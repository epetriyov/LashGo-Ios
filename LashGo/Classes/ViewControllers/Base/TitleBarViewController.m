#import "TitleBarViewController.h"
#import "Kernel.h"
#import "ViewFactory.h"

@interface TitleBarViewController ()

@end

@implementation TitleBarViewController

@dynamic contentFrame;
@dynamic canGoBack;

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

- (void) backAction: (id) sender {
    [kernel.viewControllersManager returnToPreviousViewController];
}

@end
