typedef NS_ENUM(short, TaskbarButtonType) {
	TaskbarButtonTypeNone = 0,
	TaskbarButtonTypeTask = 1,
	TaskbarButtonTypeFollow = 2,
	TaskbarButtonTypeActions = 3,
	TaskbarButtonTypeProfile = 4,
	TaskbarButtonTypeMore = 5
};

@protocol TaskbarButtonDelegate;

@interface TaskbarButton : UIButton {
	TaskbarButtonType type;
	
}

@property (readonly) TaskbarButtonType type;

- (id) initWithType: (TaskbarButtonType) buttonType;

@end
