#import "ViewFactory.h"
#import "FontFactory.h"
#import "Common.h"

static ViewFactory *viewFactory = nil;

@interface ViewFactory () {
}

@end

@implementation ViewFactory

#define kResourceSuffixHighlighted @"_hl"
#define kResourceSuffixSelected @"_sel"
#define kResourceSuffixBackground @"_bg"

@dynamic iconEmail, iconPassword;
@dynamic lgLogoImage;
@dynamic loginViewControllerBgImage;
@dynamic startViewControllerBgImage, startViewControllerFrameImage, startViewControllerGradientImage, statusBarPreferredColor;
@dynamic taskbarBackgroundView, titleBarBackgroundImage, titleBarLogoImage;

+ (ViewFactory *) sharedFactory {
	if (viewFactory == nil) {
		viewFactory = [[ViewFactory alloc] init];
	}
	return viewFactory;
}


- (UIImage *) getImageWithName: (NSString *) imageName {
	NSString *pathForResource = [[NSBundle mainBundle] pathForResource: imageName ofType: @"png"];
	return [UIImage imageWithContentsOfFile: pathForResource];
}

#pragma mark -

- (UIImage *) iconEmail {
	return [self getImageWithName: @"e-mail"];
}

- (UIImage *) iconPassword {
	return [self getImageWithName: @"lock"];
}

- (UIImage *) lgLogoImage {
	return [self getImageWithName: @"logo_lg"];
}

- (UIImage *) loginViewControllerBgImage {
	return [self getImageWithName: @"bg_login"];
}

- (UIImage *) startViewControllerBgImage {
	return [self getImageWithName: @"photo_intro"];
}

- (UIImage *) startViewControllerFrameImage {
	return [self getImageWithName: @"frame"];
}

- (UIImage *) startViewControllerGradientImage {
	return [self getImageWithName: @"gradient_intro"];
}

- (UIColor *) statusBarPreferredColor {
	return [UIColor blackColor];
}

- (UIView *) taskbarBackgroundView {
	UIView *view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 1, 49)];
	view.backgroundColor = [UIColor colorWithWhite: 226.0/255.0 alpha: 1.0];
	return view;
}

- (UIImage *) titleBarBackgroundImage {
	if (titleBarBackgroundImage == nil) {
		titleBarBackgroundImage = [self getImageWithName: @"title_bar_bg"];
	}
	return titleBarBackgroundImage;
}

- (UIImage *) titleBarLogoImage {
	if (titleBarLogoImage == nil) {
		titleBarLogoImage = [self getImageWithName: @"title_bar_logo"];
	}
	return titleBarLogoImage;
}

#pragma mark -

- (UIButton *) buttonWithImageName:(NSString *) imageName target: (id) target action: (SEL) selector {
	NSString *imageExt = @".png";
	UIButton *button = [ [UIButton alloc] init];
	[button addTarget: target action: selector forControlEvents: UIControlEventTouchUpInside];
	
	UIImage *image = [UIImage imageNamed: [imageName stringByAppendingString:imageExt]];
	[button setImage: image
					  forState: UIControlStateNormal];
	[button setImage: [UIImage imageNamed: [imageName stringByAppendingFormat: @"%@%@",
													  kResourceSuffixHighlighted, imageExt]]
					  forState: UIControlStateHighlighted];
	[button setImage: [UIImage imageNamed: [imageName stringByAppendingFormat: @"%@%@",
													  kResourceSuffixSelected, imageExt]]
					  forState: UIControlStateSelected];
	
	//	NSString *bgImageName = [imageName stringByAppendingString: kResourceSuffixBackground];
	//	[button setBackgroundImage: [UIImage imageNamed: [bgImageName stringByAppendingString:imageExt]]
	//					  forState: UIControlStateNormal];
	//	[button setBackgroundImage: [UIImage imageNamed: [bgImageName stringByAppendingFormat: @"%@%@",
	//													  kResourceSuffixSelected, imageExt]]
	//					  forState: UIControlStateSelected];
	
	button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
	return button;
}

- (UIButton *) buttonWithBGImageName:(NSString *) imageName target: (id) target action: (SEL) selector {
	NSString *imageExt = @".png";
	UIButton *button = [ [UIButton alloc] init];
	[button addTarget: target action: selector forControlEvents: UIControlEventTouchUpInside];

	UIImage *image = [UIImage imageNamed: [imageName stringByAppendingString:imageExt]];
	[button setBackgroundImage: image
					  forState: UIControlStateNormal];
	[button setBackgroundImage: [UIImage imageNamed: [imageName stringByAppendingFormat: @"%@%@",
													  kResourceSuffixHighlighted, imageExt]]
					  forState: UIControlStateHighlighted];
	[button setBackgroundImage: [UIImage imageNamed: [imageName stringByAppendingFormat: @"%@%@",
													  kResourceSuffixSelected, imageExt]]
					  forState: UIControlStateSelected];
	
//	NSString *bgImageName = [imageName stringByAppendingString: kResourceSuffixBackground];
//	[button setBackgroundImage: [UIImage imageNamed: [bgImageName stringByAppendingString:imageExt]]
//					  forState: UIControlStateNormal];
//	[button setBackgroundImage: [UIImage imageNamed: [bgImageName stringByAppendingFormat: @"%@%@",
//													  kResourceSuffixSelected, imageExt]]
//					  forState: UIControlStateSelected];

	button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
	return button;
}

#pragma mark - Login

- (UIButton *) loginButtonWithTarget: (id) target action: (SEL) selector {
	UIButton *button = [self buttonWithBGImageName: @"button_go" target: target action: selector];
	button.titleLabel.font = [FontFactory fontWithType: FontTypeLoginActionBtnTitle];
	[button setTitle: @"LoginViewControllerLoginBtnTitle".commonLocalizedString forState: UIControlStateNormal];
	[button setTitleColor: [FontFactory fontColorForType: FontTypeLoginActionBtnTitle] forState: UIControlStateNormal];
	
	return button;
}

- (UIButton *) loginFacebookButtonWithTarget: (id) target action: (SEL) selector {
	UIButton *button = [self buttonWithBGImageName: @"btn_facebook" target: target action: selector];
	return button;
}

- (UIButton *) loginTwitterButtonWithTarget: (id) target action: (SEL) selector {
	UIButton *button = [self buttonWithBGImageName: @"btn_twitter" target: target action: selector];
	return button;
}

- (UIButton *) loginVkontakteButtonWithTarget: (id) target action: (SEL) selector {
	UIButton *button = [self buttonWithBGImageName: @"btn_vk" target: target action: selector];
	return button;
}

#pragma mark - Title bar

- (UIButton *) titleBarBackButtonWithTarget: (id) target action: (SEL) selector {
	UIButton *button = [self buttonWithBGImageName: @"ic_back" target: target action: selector];
	button.titleLabel.font = [FontFactory fontWithType: FontTypeTitleBarButtons];
	return button;
}

- (UIButton *) titleBarCheckCardsButtonWithTarget: (id) target action: (SEL) selector {
	UIButton *button = [self buttonWithBGImageName: @"ic_switch_card" target: target action: selector];
	return button;
}

- (UIButton *) titleBarCheckListButtonWithTarget: (id) target action: (SEL) selector {
	UIButton *button = [self buttonWithBGImageName: @"ic_switch_feed" target: target action: selector];
	return button;
}

- (UIButton *) titleBarRightButtonWithText: (NSString *) text target: (id) target action: (SEL) selector {
	UIButton *button = [ [UIButton alloc] initWithFrame: CGRectMake(0, 0, 60, 32)];
	[button addTarget: target action: selector forControlEvents: UIControlEventTouchUpInside];
	
	button.titleLabel.adjustsFontSizeToFitWidth = YES;
	button.titleLabel.font = [FontFactory fontWithType: FontTypeTitleBarButtons];
	[button setTitle: text forState: UIControlStateNormal];
	[button setTitleColor: [FontFactory fontColorForType: FontTypeTitleBarButtons] forState: UIControlStateNormal];
	
	return button;
}

- (UIButton *) titleBarRightIncomeButtonWithTarget: (id) target action: (SEL) selector {
	UIButton *button = [self buttonWithBGImageName: @"ic_notifications" target: target action: selector];
	return button;
}

- (UIButton *) titleBarRightSearchButtonWithTarget: (id) target action: (SEL) selector {
	UIButton *button = [self buttonWithBGImageName: @"ic_search" target: target action: selector];
	return button;
}

@end
