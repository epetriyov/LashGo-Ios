#import "TaskbarButton.h"

@protocol TaskbarDelegate;

@interface Taskbar : UIView {
	UIView *backgroundView;
	NSArray *buttonsTypes;
	NSMutableArray *buttons;
}

@property (nonatomic, weak) id<TaskbarDelegate> delegate;

- (void) setBackgroundView: (UIView *) bgView;
- (void) setButtonsTypes: (NSArray *) btnTypes;

- (void) selectButtonWithType: (TaskbarButtonType) buttonType;
- (void) deselectButtons;

@end

@protocol TaskbarDelegate <NSObject>

@required
- (void) taskbar: (Taskbar *) taskbar didSelectedButton: (TaskbarButton *) button;
@end

