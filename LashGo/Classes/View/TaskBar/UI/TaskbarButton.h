typedef NS_ENUM(short, TaskbarButtonType) {
	TaskbarButtonTypeNone = 0,
	TaskbarButtonTypeKeeper = 1,
	TaskbarButtonTypeInfo = 2,
	TaskbarButtonTypeOffer = 3,
	TaskbarButtonTypeSettings = 4,
	TaskbarButtonTypeSearch = 5
};

@protocol TaskbarButtonDelegate;

@interface TaskbarButton : UIButton {
	TaskbarButtonType type;
	
}

@property (readonly) TaskbarButtonType type;

- (id) initWithType: (TaskbarButtonType) buttonType;

@end
