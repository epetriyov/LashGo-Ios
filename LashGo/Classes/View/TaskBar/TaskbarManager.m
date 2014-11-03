#import "TaskbarManager.h"
#import "UIView+CGExtension.h"
#import "ViewFactory.h"

#define kAnimationDuration 0.5
#define kTaskbarHeight 49

@interface TaskbarManager () {
	UIView *taskbarDarkBackgroundView;
}

@end

@implementation TaskbarManager

@synthesize delegate;
@synthesize visibleTaskbar;

+ (TaskbarManager *) sharedManager {
	static TaskbarManager *taskbarManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		taskbarManager = [ [TaskbarManager alloc] init];
	});
	return taskbarManager;
}

- (id) init {
	if (self = [super init]) {
		taskbars = [ [NSMutableArray alloc] init];
		
		taskbarDarkBackgroundView = [ViewFactory sharedFactory].taskbarBackgroundView;
		
		usedButtonTypesStack = [ [NSMutableArray alloc] init];
		
		return self;
	}
	return nil;
}

- (CGFloat) taskbarHeight {
	return taskbarDarkBackgroundView.frame.size.height;
}

- (Taskbar *) taskbarWithButtonTypes: (NSArray *) buttonTypes {
    Taskbar *taskbar;
    taskbar = [[Taskbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, taskbarDarkBackgroundView.frame.size.height)];
	taskbar.delegate = self;
	
//	taskbarDarkBackgroundView.frameWidth = taskbar.frame.size.width;
//	[taskbar setBackgroundView: taskbarDarkBackgroundView];
	
//	[taskbar setButtonsTypes: buttonTypes];
	
	return taskbar;
}

- (Taskbar *) unusedTaskbarWithButtonTypes: (NSArray *) buttonTypes forParentSize: (CGSize) parentSize
							   contentType: (TaskbarContentType) contentType {
	Taskbar *unusedTaskbar = nil;
	for (Taskbar *taskbar in taskbars) {
		if (taskbar != self.visibleTaskbar) {
			unusedTaskbar = taskbar;
//			[taskbar setBackgroundView: taskbarDarkBackgroundView];
//			[taskbar setButtonsTypes: buttonTypes];
			
			break;
		}
	}
	if (unusedTaskbar == nil) {
		//Lazy taskbar load
		unusedTaskbar = [self taskbarWithButtonTypes: buttonTypes];
		[taskbars addObject: unusedTaskbar];
	}
	UIView *bgView;
	if (contentType == TaskbarContentTypeLight) {
		bgView = [ViewFactory sharedFactory].taskbarLightBackgroundView;
	} else {
		bgView = [ViewFactory sharedFactory].taskbarBackgroundView;
	}
	[unusedTaskbar setBackgroundView: bgView];
	[unusedTaskbar setButtonsTypes: buttonTypes];
	unusedTaskbar.frame = CGRectMake(0, parentSize.height - unusedTaskbar.frame.size.height,
									 parentSize.width, unusedTaskbar.frame.size.height);
	return unusedTaskbar;
}

- (void) showTaskbarInView: (UIView *) view withButtonTypes: (NSArray *) buttonTypes {
	for (Taskbar *taskbar in taskbars) {
		if (taskbar.superview == view) {
//			[taskbar setBackgroundView: taskbarDarkBackgroundView];
//			[taskbar setButtonsTypes: buttonTypes];
			self.visibleTaskbar = taskbar;
			
			return;
		}
	}
	Taskbar *taskbar = [self unusedTaskbarWithButtonTypes: buttonTypes forParentSize: view.frame.size
											  contentType: TaskbarContentTypeDark];
	self.visibleTaskbar = taskbar;
	[view addSubview: taskbar];
}

- (void) showTaskbarInView: (UIView *) view withButtonTypes: (NSArray *) buttonTypes
			   contentType: (TaskbarContentType) contentType {
	for (Taskbar *taskbar in taskbars) {
		if (taskbar.superview == view) {
			[taskbar setButtonsTypes: buttonTypes];
			self.visibleTaskbar = taskbar;
			
			return;
		}
	}
	Taskbar *taskbar = [self unusedTaskbarWithButtonTypes: buttonTypes forParentSize: view.frame.size
											  contentType: contentType];
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
