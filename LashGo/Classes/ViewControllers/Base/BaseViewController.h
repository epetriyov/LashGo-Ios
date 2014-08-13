@class Kernel;

@interface BaseViewController : UIViewController {
	Kernel __weak *kernel;
}

- (id) initWithKernel: (Kernel *) theKernel;

@end
