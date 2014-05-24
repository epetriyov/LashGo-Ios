
#import "FontFactory.h"

#define kDefaultFont				@"HelveticaNeue"
#define kDefaultFontCondensedBold	@"HelveticaNeue-CondensedBold"
#define kDefaultFontMedium			@"HelveticaNeue-Medium"

@implementation FontFactory

+ (UIFont *) fontWithType: (FontType) fontType {
	switch (fontType) {
		case FontTypeTitleBarButtons:			return [UIFont fontWithName: kDefaultFont size: 17];
		case FontTypeTitleBarLogoDescription:	return [UIFont fontWithName: kDefaultFontCondensedBold size: 9];
		case FontTypeTitleBarTitle:				return [UIFont fontWithName: kDefaultFontMedium size: 17];
		default:
			break;
	}
	return nil;
}

+ (UIColor *) fontColorForType: (FontType) fontType {
	switch (fontType) {
		case FontTypeTitleBarButtons:				return [UIColor whiteColor];
		default: return [UIColor blackColor];
	}
	return nil;
}

+ (UIColor *) fontShadownColorForType: (FontType) fontType {
	switch (fontType) {
		default: return [UIColor colorWithWhite: 0.9 alpha: 1];
			break;
	}
	return nil;
}

@end
