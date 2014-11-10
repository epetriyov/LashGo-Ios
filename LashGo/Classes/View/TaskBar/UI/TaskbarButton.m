#import "TaskbarButton.h"
#import "FontFactory.h"

@implementation TaskbarButton

#define kResourceSuffixHighlighted @"_hl"
#define kResourceSuffixSelected @"_sel"

- (void) loadImagesWithName:(NSString *) imageName {
	NSString *imageExt = @".png";
	
	UIImage *image = [UIImage imageNamed: [imageName stringByAppendingString:imageExt]];
	[self setImage: image
					forState: UIControlStateNormal];
	[self setImage: [UIImage imageNamed: [imageName stringByAppendingFormat: @"%@%@",
													  kResourceSuffixSelected, imageExt]]
					forState: UIControlStateSelected];
	[self setImage: [UIImage imageNamed: [imageName stringByAppendingFormat: @"%@%@",
													  kResourceSuffixSelected, imageExt]]
					forState: UIControlStateHighlighted];
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
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.imageView.contentMode = UIViewContentModeCenter;
		
		[self loadImagesWithName: [NSString stringWithFormat: @"tb_btn_%d", buttonType]];
		
		NSString *title = [self localizedTitleForType: buttonType];
		if (title != nil) {
			self.titleLabel.font = [FontFactory fontWithType: FontTypeTaskbarButtons];
			[self setTitleColor: [FontFactory fontColorForType: FontTypeTaskbarButtons] forState: UIControlStateNormal];
			[self setTitle: title forState: UIControlStateNormal];
			
			self.titleEdgeInsets = UIEdgeInsetsMake(34, - self.imageView.image.size.width, 0, 0);
			
			float titleWidth;
			if ([self.titleLabel.text respondsToSelector: @selector(sizeWithAttributes:)] == YES) {
				titleWidth = ceil([self.titleLabel.text sizeWithAttributes:
								   @{NSFontAttributeName: self.titleLabel.font}].width);
			} else {
				titleWidth = [self.titleLabel.text sizeWithFont: self.titleLabel.font].width;
			}
			self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - titleWidth);
		}
	}
	return self;
}

@end
