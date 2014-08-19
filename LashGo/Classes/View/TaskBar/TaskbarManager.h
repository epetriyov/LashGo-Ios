#import "Taskbar.h"

@protocol TaskbarManagerDelegate;

@interface TaskbarManager : NSObject <TaskbarDelegate> {
	id<TaskbarManagerDelegate> delegate;
	
	UIImage *taskbarBackgroundImage;
	
	Taskbar *visibleTaskbar;
	
	NSMutableArray *taskbars;
	
	NSMutableArray *usedButtonTypesStack;
	
    TaskbarButtonType lastHighlightedButtonType;
}

@property (nonatomic, assign) id<TaskbarManagerDelegate> delegate;
@property (nonatomic, retain) Taskbar *visibleTaskbar;

+ (TaskbarManager *) sharedManager;
- (CGFloat) taskbarHeight;
- (void) showTaskbarInView: (UIView *) view withButtonTypes: (NSArray *) buttonTypes;
- (void) pushTaskbarButtonType: (TaskbarButtonType) type;
- (TaskbarButtonType) popTaskbarButtonType;
- (TaskbarButtonType) lastUsedTaskbarButtonType;
- (void) highlightButtonWithType: (TaskbarButtonType) type;
- (void) deselectAllButtons;
- (TaskbarButtonType) getLastHighlightedButtonType;

@end

@protocol TaskbarManagerDelegate <NSObject>

@required
- (void) taskbarManager: (TaskbarManager *) manager didPressTaskbarButtonWithType: (TaskbarButtonType) type;

@end
