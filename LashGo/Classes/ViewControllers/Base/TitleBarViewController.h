#import "BaseViewController.h"
#import "RootNavigationControllerItemProtocol.h"

#import "TitleBarView.h"

@interface TitleBarViewController : BaseViewController <RootNavigationControllerItemProtocol> {
	TitleBarView __weak *_titleBarView;
	UIImageView __weak *_background;
}

@property (nonatomic, readonly) CGRect contentFrame;
@property (nonatomic, assign) BOOL canGoBack;

@end
