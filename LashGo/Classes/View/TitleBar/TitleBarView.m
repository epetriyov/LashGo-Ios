#import "TitleBarView.h"

#import "Common.h"
#import "FontFactory.h"
#import "Storage.h"
#import "UIView+CGExtension.h"
#import "ViewFactory.h"

@interface TitleBarView () {
	UISearchBar *_searchBar;
}

@property (nonatomic, strong) NSObject *counterObserver;

@end

@implementation TitleBarView

@synthesize titleLabel, backButton, rightButton;
@dynamic contentFrame;

#pragma mark - Properties

- (CGRect) contentFrame {
	CGFloat offsetY = 18;
	CGRect contentFrame = [TitleBarView titleBarRect];
	contentFrame.origin.y = offsetY;
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
		
		CGRect contentFrame = self.contentFrame;
		
		backButton = [[ViewFactory sharedFactory] titleBarBackButtonWithTarget: nil action: nil];
		backButton.center = CGPointMake(backButton.frame.size.width / 2, CGRectGetMidY(contentFrame));
		[self addSubview: backButton];

		float offsetX = backButton.frame.origin.x + backButton.frame.size.width + 15;
		titleLabel = [ [UILabel alloc] initWithFrame: CGRectMake(offsetX, contentFrame.origin.y,
																 contentFrame.size.width - offsetX * 2, contentFrame.size.height)];
		titleLabel.adjustsFontSizeToFitWidth = YES;
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.numberOfLines = 1;
		titleLabel.textAlignment = NSTextAlignmentCenter;
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.font = [FontFactory fontWithType: FontTypeTitleBarTitle];
//		titleLabel.adjustsFontSizeToFitWidth = YES;
		[self addSubview: titleLabel];
    }
    return self;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver: self.counterObserver];
}

- (void) setRightButtonCounter: (int32_t) count {
	NSString *countString = nil;
	if (count > 0) {
		countString = [NSString stringWithFormat: @" %d ", count];
	}
	[rightButton setTitle: countString forState: UIControlStateNormal];
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
	return CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 65);
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
	
	float buttonWidth = 65;
	
	CGRect rightButtonFrame = titleBar.contentFrame;
	rightButtonFrame.origin.x = rightButtonFrame.size.width - buttonWidth;
	rightButtonFrame.size.width = buttonWidth;
	
	UIButton *rightButton = [[UIButton alloc] initWithFrame: rightButtonFrame];
	rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
	[rightButton.titleLabel setFont: [FontFactory fontWithType: FontTypeTitleBarButtons]];
	[rightButton setTitle: text forState: UIControlStateNormal];
	[rightButton setTitleColor: [FontFactory fontColorForType: FontTypeTitleBarButtons]
					  forState: UIControlStateNormal];
	[titleBar addSubview: rightButton];
	
	titleBar -> rightButton = rightButton;
	
	return titleBar;
}

+ (TitleBarView *) titleBarViewWithRightButtonWithText: (NSString *) text
										searchDelegate: (id<UISearchBarDelegate>) delegate {
	TitleBarView *titleBar = [TitleBarView titleBarView];
	
	titleBar.backButton.alpha = 0;
	
	UIButton *rightButton = [[ViewFactory sharedFactory] titleBarRightButtonWithText: text target: nil action: nil];
	
	CGFloat capX = 3;
	CGRect contentFrame = titleBar.contentFrame;
	
	rightButton.frameX = contentFrame.size.width - (rightButton.frame.size.width + capX);
	rightButton.centerY = CGRectGetMidY(contentFrame);
	[titleBar addSubview: rightButton];
	
	titleBar -> rightButton = rightButton;
	
	UISearchBar *bar = [[UISearchBar alloc] initWithFrame: CGRectMake(0, contentFrame.origin.y, rightButton.frame.origin.x + capX,
																	  contentFrame.size.height)];
	bar.backgroundImage = [[UIImage alloc] init];
	bar.delegate = delegate;
	bar.placeholder = @"Поиск".commonLocalizedString;
	[titleBar addSubview: bar];
	
	titleBar -> _searchBar = bar;
	
	return titleBar;
}

+ (TitleBarView *) titleBarViewWithRightButtons: (NSArray *) buttons {
	TitleBarView *titleBar = [TitleBarView titleBarView];
	
	CGFloat centerY = CGRectGetMidY(titleBar.contentFrame);
	CGFloat offsetX = titleBar.frame.size.width;
	
	for (ushort i = 0; i < [buttons count]; ++i) {
		UIButton *button = buttons[i];
		
		offsetX -= button.frame.size.width;
		button.frameX = offsetX;
		button.centerY = centerY;
		
		[titleBar addSubview: button];
		
		if (i == 0) {
			titleBar -> rightButton = button;
		}
	}
	
	CGFloat titleOffsetX = MAX(titleBar.backButton.frame.origin.x + titleBar.backButton.frame.size.width,
							   titleBar.frame.size.width - offsetX);
	titleOffsetX += 5;
	
	CGFloat titleWidth = titleBar.frame.size.width - titleOffsetX * 2;
	titleBar.titleLabel.frameX = titleOffsetX;
	titleBar.titleLabel.frameWidth = titleWidth;
	titleBar.titleLabel.adjustsFontSizeToFitWidth = YES;
	
	return titleBar;
}

+ (TitleBarView *) titleBarViewWithLeftSecondaryButton: (UIButton *) leftButton
										   rightButton: (UIButton *) rightButton
								  rightSecondaryButton: (UIButton *) secondaryButton {
	TitleBarView *titleBar = [TitleBarView titleBarView];
	
	CGFloat centerY = CGRectGetMidY(titleBar.contentFrame);
	
	leftButton.centerY = centerY;
	leftButton.frameX = titleBar.backButton.frame.origin.x + titleBar.backButton.frame.size.width;
	[titleBar addSubview: leftButton];
	
	rightButton.frameX = titleBar.frame.size.width - (rightButton.frame.size.width);
	rightButton.centerY = centerY;
	[titleBar addSubview: rightButton];
	
	titleBar -> rightButton = rightButton;
	
	if (secondaryButton != nil) {
		secondaryButton.frameX = rightButton.frame.origin.x - (secondaryButton.frame.size.width);
		secondaryButton.centerY = centerY;
		[titleBar addSubview: secondaryButton];
	}
	
	CGFloat titleOffsetX = leftButton.frame.origin.x + leftButton.frame.size.width + 5;
	CGFloat titleWidth = titleBar.frame.size.width - titleOffsetX * 2;
	titleBar.titleLabel.frameX = titleOffsetX;
	titleBar.titleLabel.frameWidth = titleWidth;
	titleBar.titleLabel.adjustsFontSizeToFitWidth = YES;
	
	return titleBar;
}

+ (TitleBarView *) titleBarViewWithLeftButton: (UIButton *) leftButton
								  rightButton: (UIButton *) rightButton
								 searchButton: (UIButton *) searchButton {
	TitleBarView *titleBar = [TitleBarView titleBarView];
	
	titleBar.backButton.alpha = 0;
	
	CGFloat centerY = CGRectGetMidY(titleBar.contentFrame);
	
	leftButton.centerY = centerY;
	[titleBar addSubview: leftButton];
	
	rightButton.frameX = titleBar.frame.size.width - (rightButton.frame.size.width);
	rightButton.centerY = centerY;
	[titleBar addSubview: rightButton];
	
	titleBar -> rightButton = rightButton;
	
	searchButton.frameX = rightButton.frame.origin.x - (searchButton.frame.size.width);
	searchButton.centerY = centerY;
	[titleBar addSubview: searchButton];
	
	TitleBarView __weak *wself = titleBar;
	
	titleBar.counterObserver =
	[[NSNotificationCenter defaultCenter] addObserverForName: kLGStorageMainScreenInfoChangedNotification
													  object: nil
													   queue: [NSOperationQueue mainQueue]
												  usingBlock:^(NSNotification *note) {
													  LGMainScreenInfo *info = note.object;
													  [wself setRightButtonCounter: info.actionCount];
												  }];
	
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
	titleBar.backgroundColor = [UIColor colorWithRed:0 green: 172.0/255.0 blue: 193.0/255.0 alpha: 1.0];
	
	return titleBar;
}

@end
