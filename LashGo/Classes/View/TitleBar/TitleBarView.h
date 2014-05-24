
@interface TitleBarView : UIView {
	UIImageView *backgroundImageView;
	UIImageView *logoImageView;
	UIButton *backButton;
	UIButton *rightButton;
	
	UILabel *titleLabel;
}

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIButton *backButton;
@property (nonatomic, readonly) UIButton *rightButton;

+ (TitleBarView *) titleBarViewWithLogo;
+ (TitleBarView *) titleBarViewWithLogoAndRightButtonWithText: (NSString *) text;
+ (TitleBarView *) titleBarViewWithRightButtonWithText: (NSString *) text;
+ (TitleBarView *) titleBarViewWithLeftButtonText: (NSString *) leftText
								  rightButtonText: (NSString *) rightText;
+ (TitleBarView *) titleBarView;

@end
