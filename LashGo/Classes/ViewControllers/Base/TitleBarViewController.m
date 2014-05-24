#import "TitleBarViewController.h"
#import "Kernel.h"
#import "ViewFactory.h"

@interface TitleBarViewController ()

@end

@implementation TitleBarViewController

@dynamic contentFrame;
@dynamic canGoBack;

- (CGRect) contentFrame {
	float offsetY = titleBarView.frame.origin.y + titleBarView.frame.size.height;
	return CGRectMake(0, offsetY, self.view.frame.size.width, self.view.frame.size.height - offsetY);
}

- (BOOL) canGoBack {
	return titleBarView.backButton.hidden == NO && titleBarView.backButton.alpha > 0;
}

- (void) setCanGoBack:(BOOL) value {
	if (value == YES) {
		titleBarView.backButton.alpha = 1;
	} else {
		titleBarView.backButton.alpha = 0;
	}
}

- (void) loadView {
	[super loadView];
	
	background = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width,
																			 self.view.frame.size.height)];
	background.contentMode = UIViewContentModeBottomLeft;
	[self.view addSubview: background];
	[background release];
	
	titleBarView = [TitleBarView titleBarView];
	[titleBarView.backButton addTarget: self action: @selector(backAction:) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: titleBarView];
	
	if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
//		work only if navigationBarHidden == NO
//		self.edgesForExtendedLayout = UIRectEdgeNone;
		UIView *statusBarBgView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 20)];
		statusBarBgView.backgroundColor = [ViewFactory sharedFactory].statusBarPreferredColor;
		[self.view addSubview: statusBarBgView];
		[statusBarBgView release];
		
		[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent animated: NO];
    }
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
	if (kernel.viewControllersManager.isReturnToPreviousAvaliable == YES) {
		titleBarView.backButton.hidden = NO;
	} else {
		titleBarView.backButton.hidden = YES;
	}
}

- (void) backAction: (id) sender {
    [kernel.viewControllersManager returnToPreviousViewController];
}

@end
