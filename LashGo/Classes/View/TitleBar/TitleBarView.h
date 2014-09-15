
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
@property (nonatomic, readonly) CGRect contentFrame;

+ (TitleBarView *) titleBarViewWithLogo;
+ (TitleBarView *) titleBarViewWithLogoAndRightButtonWithText: (NSString *) text;
+ (TitleBarView *) titleBarViewWithRightButtonWithText: (NSString *) text;
+ (TitleBarView *) titleBarViewWithRightButtonWithText: (NSString *) text
										searchDelegate: (id<UISearchBarDelegate>) delegate;

+ (TitleBarView *) titleBarViewWithLeftButton: (UIButton *) leftButton
								  rightButton: (UIButton *) rightButton
								 searchButton: (UIButton *) searchButton;
+ (TitleBarView *) titleBarViewWithLeftButtonText: (NSString *) leftText
								  rightButtonText: (NSString *) rightText;
+ (TitleBarView *) titleBarView;

@end
