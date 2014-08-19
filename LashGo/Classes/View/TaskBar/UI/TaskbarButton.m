#import "TaskbarButton.h"
#import "FontFactory.h"

@implementation TaskbarButton

#define kResourceSuffixHighlighted @"_hl"
#define kResourceSuffixSelected @"_sel"

- (void) loadImagesWithName:(NSString *) imageName {
	NSString *imageExt = @".png";
	
	UIImage *image = [UIImage imageNamed: [imageName stringByAppendingString:imageExt]];
	[self setBackgroundImage: image
					forState: UIControlStateNormal];
	[self setBackgroundImage: [UIImage imageNamed: [imageName stringByAppendingFormat: @"%@%@",
													  kResourceSuffixSelected, imageExt]]
					forState: UIControlStateSelected];
	[self setBackgroundImage: [UIImage imageNamed: [imageName stringByAppendingFormat: @"%@%@",
													  kResourceSuffixSelected, imageExt]]
					forState: UIControlStateHighlighted];
	self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
}

- (NSString *) localizedTitleForType: (TaskbarButtonType) buttonType {
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
	
	NSString *key = [NSString stringWithFormat: @"title_%d", buttonType];
    NSString *locString = [thisBundle localizedStringForKey: key
													  value: nil table: @"TaskbarButtonLocalizable"];
	if ([locString isEqualToString: key] == YES) {
		locString = nil;
	}
	return locString;
}


#pragma mark Getters and setters

@synthesize type;

#pragma mark Standard overrides


#pragma mark Methods implementation

- (id) initWithType: (TaskbarButtonType) buttonType {
	if (self = [super init]) {
		type = buttonType;
		
		[self loadImagesWithName: [NSString stringWithFormat: @"taskbar_btn_%d", buttonType]];
		
		NSString *title = [self localizedTitleForType: buttonType];
		if (title != nil) {
			self.titleLabel.font = [FontFactory fontWithType: FontTypeTaskbarButtons];
			[self setTitleColor: [FontFactory fontColorForType: FontTypeTaskbarButtons] forState: UIControlStateNormal];
			[self setTitle: title forState: UIControlStateNormal];
			self.titleEdgeInsets = UIEdgeInsetsMake(38, 0, 2, 0);
		}
	}
	return self;
}

@end
