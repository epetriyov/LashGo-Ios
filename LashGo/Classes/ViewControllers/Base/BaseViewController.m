#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id) initWithKernel:(Kernel *)theKernel {
	if (self = [super init]) {
		kernel = theKernel;
	}
	
	return self;
}

@end
