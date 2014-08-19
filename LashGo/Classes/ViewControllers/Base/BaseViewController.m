#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id) initWithKernel:(Kernel *)theKernel {
	if (self = [super init]) {
		kernel = theKernel;
		if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
			self.wantsFullScreenLayout = YES;
		}
	}
	
	return self;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
	return UIStatusBarStyleDefault;
}

@end
