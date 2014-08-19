#import "TaskbarManager.h"
#import "ViewFactory.h"

#define kAnimationDuration 0.5
#define kTaskbarHeight 49

static TaskbarManager *taskbarManager;

@interface TaskbarManager (private)

- (Taskbar *) newTaskbar;

@end



@implementation TaskbarManager

@synthesize delegate;
@synthesize visibleTaskbar;

+ (TaskbarManager *) sharedManager {
	if (taskbarManager == nil) {
		taskbarManager = [ [TaskbarManager alloc] init];
	}
	return taskbarManager;
}

- (id) init {
	if (self = [super init]) {
		taskbars = [ [NSMutableArray alloc] init];
		
		taskbarBackgroundImage = [[ViewFactory sharedFactory].taskbarBackgroundImage retain];
		
		usedButtonTypesStack = [ [NSMutableArray alloc] init];
		
		return self;
	}
	return nil;
}

- (void) dealloc {
	self.delegate = nil;
	self.visibleTaskbar = nil;
	
	[taskbars release];
	[taskbarBackgroundImage release];
	[usedButtonTypesStack release];
	
	[super dealloc];
}

- (CGFloat) taskbarHeight {
	return taskbarBackgroundImage.size.height;
}

- (Taskbar *) taskbarWithButtonTypes: (NSArray *) buttonTypes {
    Taskbar *taskbar;
    taskbar = [ [ [Taskbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, taskbarBackgroundImage.size.height)] autorelease];
	taskbar.delegate = self;
	UIImageView *imageView = [[UIImageView alloc] initWithImage: taskbarBackgroundImage];
	imageView.contentMode = UIViewContentModeScaleToFill;
	[taskbar setBackgroundView: imageView];
	[imageView release];
	
	[taskbar setButtonsTypes: buttonTypes];
	
	return taskbar;
}

- (Taskbar *) unusedTaskbarWithButtonTypes: (NSArray *) buttonTypes forParentSize: (CGSize) parentSize {
	Taskbar *unusedTaskbar = nil;
	for (Taskbar *taskbar in taskbars) {
		if (taskbar != self.visibleTaskbar) {
			unusedTaskbar = taskbar;
			[taskbar setButtonsTypes: buttonTypes];
			
			break;
		}
	}
	if (unusedTaskbar == nil) {
		//Lazy taskbar load
		unusedTaskbar = [self taskbarWithButtonTypes: buttonTypes];
		[taskbars addObject: unusedTaskbar];
	}
	unusedTaskbar.frame = CGRectMake(0, parentSize.height - unusedTaskbar.frame.size.height,
									 parentSize.width, unusedTaskbar.frame.size.height);
	return unusedTaskbar;
}

- (void) showTaskbarInView: (UIView *) view withButtonTypes: (NSArray *) buttonTypes {
	for (Taskbar *taskbar in taskbars) {
		if (taskbar.superview == view) {
			[taskbar setButtonsTypes: buttonTypes];
			self.visibleTaskbar = taskbar;
			
			return;
		}
	}
	Taskbar *taskbar = [self unusedTaskbarWithButtonTypes:buttonTypes forParentSize: view.frame.size];
	self.visibleTaskbar = taskbar;
	[view addSubview: taskbar];
}

#pragma mark -

- (void) highlightButtonWithType: (TaskbarButtonType) type {
	for (Taskbar *taskbar in taskbars) {
		[taskbar selectButtonWithType: type];
        lastHighlightedButtonType = type;
	}
}

- (void) deselectAllButtons {
	for (Taskbar *taskbar in taskbars) {
		[taskbar deselectButtons];
	}
}

- (TaskbarButtonType) lastUsedTaskbarButtonType {
	return [ [usedButtonTypesStack lastObject] intValue];
}

- (void) pushTaskbarButtonType: (TaskbarButtonType) type {
	[usedButtonTypesStack addObject: @(type)];
	[self highlightButtonWithType: type];
}

- (TaskbarButtonType) popTaskbarButtonType {
	TaskbarButtonType buttonType = [self lastUsedTaskbarButtonType];
	[usedButtonTypesStack removeLastObject];
	[self highlightButtonWithType: [self lastUsedTaskbarButtonType] ];
	return buttonType;
}

- (TaskbarButtonType) getLastHighlightedButtonType {
    return lastHighlightedButtonType;
}

#pragma mark TaskbarDelegate methods
 
- (void) taskbar: (Taskbar *) taskbar didSelectedButton: (TaskbarButton *) button {
	if ([self.delegate respondsToSelector: @selector(taskbarManager:didPressTaskbarButtonWithType:)]) {
		[self.delegate taskbarManager: self didPressTaskbarButtonWithType: button.type];
	}
}

@end
