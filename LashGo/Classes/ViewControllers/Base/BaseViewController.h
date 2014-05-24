@class Kernel;

@interface BaseViewController : UIViewController {
	Kernel *kernel;
}

- (id) initWithKernel: (Kernel *) theKernel;

@end
