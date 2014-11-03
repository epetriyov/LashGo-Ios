#import "Taskbar.h"

typedef NS_ENUM(ushort, TaskbarContentType) {
	TaskbarContentTypeDark,
	TaskbarContentTypeLight
};

@protocol TaskbarManagerDelegate;

@interface TaskbarManager : NSObject <TaskbarDelegate> {
	NSMutableArray *taskbars;
	
	NSMutableArray *usedButtonTypesStack;
	
    TaskbarButtonType lastHighlightedButtonType;
}

@property (nonatomic, weak) id<TaskbarManagerDelegate> delegate;
@property (nonatomic, retain) Taskbar *visibleTaskbar;

+ (TaskbarManager *) sharedManager;
- (CGFloat) taskbarHeight;
- (void) showTaskbarInView: (UIView *) view withButtonTypes: (NSArray *) buttonTypes;
- (void) showTaskbarInView: (UIView *) view withButtonTypes: (NSArray *) buttonTypes
			   contentType: (TaskbarContentType) contentType;
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
