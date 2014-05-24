#import "ViewFactory.h"
#import "FontFactory.h"
#import "Common.h"

static ViewFactory *viewFactory = nil;

@implementation ViewFactory

#define kResourceSuffixHighlighted @"_hl"
#define kResourceSuffixSelected @"_sel"
#define kResourceSuffixBackground @"_bg"

@dynamic statusBarPreferredColor, titleBarBackgroundImage, titleBarLogoImage;

+ (ViewFactory *) sharedFactory {
	if (viewFactory == nil) {
		viewFactory = [[ViewFactory alloc] init];
	}
	return viewFactory;
}

- (void) dealloc {
	[titleBarBackgroundImage release];
	[titleBarLogoImage release];
	
	[super dealloc];
}

- (UIImage *) getImageWithName: (NSString *) imageName {
	NSString *pathForResource = [[NSBundle mainBundle] pathForResource: imageName ofType: @"png"];
	return [UIImage imageWithContentsOfFile: pathForResource];
}

- (UIColor *) statusBarPreferredColor {
	return [UIColor blackColor];
}

- (UIImage *) titleBarBackgroundImage {
	if (titleBarBackgroundImage == nil) {
		titleBarBackgroundImage = [[self getImageWithName: @"title_bar_bg"] retain];
	}
	return titleBarBackgroundImage;
}

- (UIImage *) titleBarLogoImage {
	if (titleBarLogoImage == nil) {
		titleBarLogoImage = [[self getImageWithName: @"title_bar_logo"] retain];
	}
	return titleBarLogoImage;
}

#pragma mark -

- (UIButton *) buttonWithImageName:(NSString *) imageName target: (id) target action: (SEL) selector {
	NSString *imageExt = @".png";
	UIButton *button = [ [ [UIButton alloc] init] autorelease];
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
	UIButton *button = [ [ [UIButton alloc] init] autorelease];
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

- (UIButton *) titleBarBackButtonWithTarget: (id) target action: (SEL) selector {
	UIButton *button = [self buttonWithBGImageName: @"title_bar_back_btn" target: target action: selector];
	button.titleLabel.font = [FontFactory fontWithType: FontTypeTitleBarButtons];
	return button;
}

- (UIButton *) titleBarRightButtonWithText: (NSString *) text target: (id) target action: (SEL) selector {
	UIButton *button = [self buttonWithBGImageName: @"title_bar_right_btn" target: target action: selector];
	button.titleLabel.font = [FontFactory fontWithType: FontTypeTitleBarButtons];
	[button setTitle: text forState: UIControlStateNormal];
	return button;
}

@end
