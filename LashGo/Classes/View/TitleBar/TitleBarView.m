#import "TitleBarView.h"

#import "Common.h"
#import "FontFactory.h"
#import "UIView+CGExtension.h"
#import "ViewFactory.h"

@interface TitleBarView () {
	UISearchBar *_searchBar;
}

@end

@implementation TitleBarView

@synthesize titleLabel, backButton, rightButton;
@dynamic contentFrame;

#pragma mark - Properties

- (CGRect) contentFrame {
	CGFloat offsetY = 20;
	CGRect contentFrame = [TitleBarView titleBarRect];
	contentFrame.origin.y = 20;
	contentFrame.size.height -= offsetY;
	
	return contentFrame;
}

#pragma mark - Overrides

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        backgroundImageView = [ [UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		backgroundImageView.contentMode = UIViewContentModeScaleToFill;
		backgroundImageView.image = [[ViewFactory sharedFactory] titleBarBackgroundImage];
		[self addSubview: backgroundImageView];
		
		backButton = [[ViewFactory sharedFactory] titleBarBackButtonWithTarget: nil action: nil];
		backButton.center = CGPointMake(backButton.frame.size.width / 2, backgroundImageView.center.y);
		[self addSubview: backButton];

		float offsetX = backButton.frame.origin.x + backButton.frame.size.width + 15;
		titleLabel = [ [UILabel alloc] initWithFrame: CGRectMake(offsetX, 0,
																 self.frame.size.width - offsetX * 2, self.frame.size.height)];
		titleLabel.adjustsFontSizeToFitWidth = YES;
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.textAlignment = NSTextAlignmentCenter;
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.font = [FontFactory fontWithType: FontTypeTitleBarTitle];
//		titleLabel.adjustsFontSizeToFitWidth = YES;
		[self addSubview: titleLabel];
    }
    return self;
}

+ (CGRect) titleBarRect {
//	UIImage *image = [[ViewFactory sharedFactory] titleBarBackgroundImage];
//
//	float offsetY = 0;
//	
//	if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
//		offsetY = 20;
//	}
//	return CGRectMake(0, offsetY, [UIScreen mainScreen].bounds.size.width,
//					  image.size.height);
	return CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 63);
}

+ (TitleBarView *) titleBarViewWithLogo {
	TitleBarView *titleBar = [TitleBarView titleBarView];
	
#ifdef DEBUG
	UILabel *buildVersionLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 60, 15)];
	buildVersionLabel.backgroundColor = [UIColor clearColor];
	buildVersionLabel.textColor = [FontFactory fontColorForType: FontTypeTitleBarButtons];
	buildVersionLabel.adjustsFontSizeToFitWidth = YES;
	buildVersionLabel.text = [NSString stringWithFormat: @"build %@#%@", [Common appVersion], [Common appBuild]];
	[titleBar addSubview: buildVersionLabel];
#endif
	
	titleBar.backButton.alpha = 0;
	
	UIImage *logoImage = [[ViewFactory sharedFactory] titleBarLogoImage];
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage: logoImage];
	logoImageView.center = CGPointMake(titleBar.frame.size.width / 2, titleBar.frame.size.height / 2);
	
	[titleBar addSubview: logoImageView];
	
	titleBar -> logoImageView = logoImageView;
	
	return titleBar;
}

+ (TitleBarView *) titleBarViewWithLogoAndRightButtonWithText: (NSString *) text {
	TitleBarView *titleBar = [TitleBarView titleBarViewWithLogo];
	
	UIButton *rightButton = [[ViewFactory sharedFactory] titleBarRightButtonWithText: text target: nil action: nil];
	
	if ([rightButton backgroundImageForState: UIControlStateNormal] != nil) {
		rightButton.center = CGPointMake(titleBar.frame.size.width - rightButton.frame.size.width / 2 - 10,
										 titleBar -> backgroundImageView.center.y);
		[titleBar addSubview: rightButton];
		
		titleBar -> rightButton = rightButton;
	} else {
		float capX = 3;
		float buttonWidth = 80;
		float buttonHeight = 32;
		
		CGRect rightButtonFrame = CGRectMake(capX, (titleBar.frame.size.height - buttonHeight) / 2,
											 buttonWidth, buttonHeight);
		rightButtonFrame.origin.x = titleBar.frame.size.width - capX - rightButtonFrame.size.width;
		
		UIButton *rightButton = [[UIButton alloc] initWithFrame: rightButtonFrame];
		[rightButton.titleLabel setFont: [FontFactory fontWithType: FontTypeTitleBarButtons]];
		rightButton.titleLabel.textColor = [UIColor whiteColor];
		[rightButton setTitle: text forState: UIControlStateNormal];
		[titleBar addSubview: rightButton];
		
		titleBar -> rightButton = rightButton;
	}
	
	return titleBar;
}

+ (TitleBarView *) titleBarViewWithRightButtonWithText: (NSString *) text {
	TitleBarView *titleBar = [TitleBarView titleBarView];
	
	UIButton *rightButton = [[ViewFactory sharedFactory] titleBarRightButtonWithText: text target: nil action: nil];
	
	if ([rightButton backgroundImageForState: UIControlStateNormal] != nil) {
		rightButton.center = CGPointMake(titleBar.frame.size.width - rightButton.frame.size.width / 2 - 10,
										 titleBar -> backgroundImageView.center.y);
		[titleBar addSubview: rightButton];
		
		titleBar -> rightButton = rightButton;
	} else {
		float capX = 3;
		float buttonWidth = 60;
		float buttonHeight = 32;
		
		CGRect rightButtonFrame = CGRectMake(capX, (titleBar.frame.size.height - buttonHeight) / 2,
											 buttonWidth, buttonHeight);
		rightButtonFrame.origin.x = titleBar.frame.size.width - capX - rightButtonFrame.size.width;
		
		UIButton *rightButton = [[UIButton alloc] initWithFrame: rightButtonFrame];
		rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
		[rightButton.titleLabel setFont: [FontFactory fontWithType: FontTypeTitleBarButtons]];
		rightButton.titleLabel.textColor = [UIColor whiteColor];
		[rightButton setTitle: text forState: UIControlStateNormal];
		[titleBar addSubview: rightButton];
		
		titleBar -> rightButton = rightButton;
	}
	
	return titleBar;
}

+ (TitleBarView *) titleBarViewWithSearchAndRightButtonWithText: (NSString *) text {
	TitleBarView *titleBar = [TitleBarView titleBarView];
	
	titleBar.backButton.alpha = 0;
	
	UIButton *rightButton = [[ViewFactory sharedFactory] titleBarRightButtonWithText: text target: nil action: nil];
	float capX = 3;
	
	rightButton.frameX = titleBar.frame.size.width - (rightButton.frame.size.width + capX);
	rightButton.centerY = CGRectGetMidY(titleBar.contentFrame);
	
	[titleBar addSubview: rightButton];
	
	titleBar -> rightButton = rightButton;
	
	UISearchBar *bar = [[UISearchBar alloc] initWithFrame: CGRectMake(0, 0, titleBar.contentFrame.size.width,
																	  titleBar.contentFrame.size.height)];
	bar.placeholder = @"Поиск".commonLocalizedString;
	bar.backgroundImage = nil;
	[titleBar addSubview: bar];
	
	titleBar -> _searchBar = bar;
	
	return titleBar;
}

+ (TitleBarView *) titleBarViewWithLeftButton: (UIButton *) leftButton
								  rightButton: (UIButton *) rightButton
								 searchButton: (UIButton *) searchButton {
	TitleBarView *titleBar = [TitleBarView titleBarView];
	
	titleBar.backButton.alpha = 0;
	
	CGFloat capX = 5;
	CGFloat centerY = CGRectGetMidY(titleBar.contentFrame);
	
	leftButton.frameX = capX;
	leftButton.centerY = centerY;
	[titleBar addSubview: leftButton];
	
	rightButton.frameX = titleBar.frame.size.width - (rightButton.frame.size.width + capX * 2);
	rightButton.centerY = centerY;
	[titleBar addSubview: rightButton];
	
	titleBar -> rightButton = rightButton;
	
	searchButton.frameX = rightButton.frame.origin.x - (searchButton.frame.size.width + capX * 2);
	searchButton.centerY = rightButton.center.y;
	[titleBar addSubview: searchButton];
	
	return titleBar;
}

+ (TitleBarView *) titleBarViewWithLeftButtonText: (NSString *) leftText
								  rightButtonText: (NSString *) rightText {
	TitleBarView *titleBar = [TitleBarView titleBarView];
	
	float capX = 7;
	float buttonWidth = 80;
	float buttonHeight = 32;
	
	CGRect leftButtonFrame = CGRectMake(capX, (titleBar.frame.size.height - buttonHeight) / 2,
										buttonWidth, buttonHeight);
	CGRect rightButtonFrame = leftButtonFrame;
	rightButtonFrame.origin.x = titleBar.frame.size.width - capX - rightButtonFrame.size.width;
	CGRect titleLabelFrame = leftButtonFrame;
	titleLabelFrame.origin.x += leftButtonFrame.size.width;
	titleLabelFrame.size.width = rightButtonFrame.origin.x - titleLabelFrame.origin.x;
	
	titleBar -> titleLabel.frame = titleLabelFrame;
	
	UIButton *rightButton = [[UIButton alloc] initWithFrame: rightButtonFrame];
	[rightButton.titleLabel setFont: [FontFactory fontWithType: FontTypeTitleBarButtons]];
	rightButton.titleLabel.textColor = [UIColor whiteColor];
	[rightButton setTitle: rightText forState: UIControlStateNormal];
	[titleBar addSubview: rightButton];
	
	titleBar -> rightButton = rightButton;
	
	[titleBar -> backButton setBackgroundImage: nil
									  forState: UIControlStateNormal];
	[titleBar -> backButton setBackgroundImage: nil
									  forState: UIControlStateHighlighted];
	[titleBar -> backButton setBackgroundImage: nil
									  forState: UIControlStateSelected];
	(titleBar -> backButton).frame = leftButtonFrame;
	[titleBar -> backButton setTitle: leftText forState: UIControlStateNormal];
	
	return titleBar;
}

+ (TitleBarView *) titleBarView {
	TitleBarView *titleBar = [[TitleBarView alloc] initWithFrame: [TitleBarView titleBarRect]];
	titleBar.backgroundColor = [UIColor colorWithRed:0 green: 0.67 blue: 0.76 alpha: 1.0];
	
	return titleBar;
}

@end
