#import "BaseViewController.h"
#import "RootNavigationControllerItemProtocol.h"

#import "TitleBarView.h"

@interface TitleBarViewController : BaseViewController <RootNavigationControllerItemProtocol> {
	TitleBarView *titleBarView;
	UIImageView *background;
}

@property (nonatomic, readonly) CGRect contentFrame;
@property (nonatomic, assign) BOOL canGoBack;

@end
