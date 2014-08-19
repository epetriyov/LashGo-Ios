#import "TaskbarButton.h"

@protocol TaskbarDelegate;

@interface Taskbar : UIView {
	id<TaskbarDelegate> delegate;
	
	UIView *backgroundView;
	NSArray *buttonsTypes;
	NSMutableArray *buttons;
}

@property (nonatomic, assign) id<TaskbarDelegate> delegate;

- (void) setBackgroundView: (UIView *) bgView;
- (void) setButtonsTypes: (NSArray *) btnTypes;

- (void) selectButtonWithType: (TaskbarButtonType) buttonType;
- (void) deselectButtons;

@end

@protocol TaskbarDelegate <NSObject>

@required
- (void) taskbar: (Taskbar *) taskbar didSelectedButton: (TaskbarButton *) button;
@end

