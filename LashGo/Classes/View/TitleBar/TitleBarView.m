#import "TitleBarView.h"
#import "ViewFactory.h"
#import "FontFactory.h"
#import "Common.h"

@implementation TitleBarView

@synthesize titleLabel, backButton, rightButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        backgroundImageView = [ [UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		backgroundImageView.contentMode = UIViewContentModeScaleToFill;
		backgroundImageView.image = [[ViewFactory sharedFactory] titleBarBackgroundImage];
		[self addSubview: backgroundImageView];
		[backgroundImageView release];
		
		backButton = [[ViewFactory sharedFactory] titleBarBackButtonWithTarget: nil action: nil];
		backButton.center = CGPointMake(backButton.frame.size.width / 2, backgroundImageView.center.y);
		[self addSubview: backButton];

		float offsetX = backButton.frame.origin.x + backButton.frame.size.width + 15;
		titleLabel = [ [UILabel alloc] initWithFrame: CGRectMake(offsetX, 0,
																 self.frame.size.width - offsetX * 2, self.frame.size.height)];
		titleLabel.adjustsFontSizeToFitWidth = YES;
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.textAlignment = UITextAlignmentCenter;
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.font = [FontFactory fontWithType: FontTypeTitleBarTitle];
//		titleLabel.adjustsFontSizeToFitWidth = YES;
		[self addSubview: titleLabel];
		[titleLabel release];
    }
    return self;
}

+ (CGRect) titleBarRect {
	UIImage *image = [[ViewFactory sharedFactory] titleBarBackgroundImage];

	float offsetY = 0;
	
	if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
		offsetY = 20;
	}
	return CGRectMake(0, offsetY, [UIScreen mainScreen].bounds.size.width,
					  image.size.height);
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
	[buildVersionLabel release];
#endif
	
	titleBar.backButton.alpha = 0;
	
	UIImage *logoImage = [[ViewFactory sharedFactory] titleBarLogoImage];
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage: logoImage];
	logoImageView.center = CGPointMake(titleBar.frame.size.width / 2, titleBar.frame.size.height / 2);
	
	[titleBar addSubview: logoImageView];
	[logoImageView release];
	
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
	TitleBarView *titleBar = [[[TitleBarView alloc] initWithFrame: [TitleBarView titleBarRect]] autorelease];
	
	return titleBar;
}

@end
