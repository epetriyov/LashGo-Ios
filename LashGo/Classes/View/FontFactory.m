
#import "FontFactory.h"

#define kDefaultFont				@"HelveticaNeue"
#define kDefaultFontCondensedBold	@"HelveticaNeue-CondensedBold"
#define kDefaultFontMedium			@"HelveticaNeue-Medium"

@implementation FontFactory

+ (UIFont *) fontWithType: (FontType) fontType {
	switch (fontType) {
		case FontTypeCheckCardDescription:		return [UIFont fontWithName: kDefaultFontMedium size: 16];
		case FontTypeCheckCardTitle:			return [UIFont fontWithName: kDefaultFont size: 20];
		case FontTypeCheckListCellTitle:
		case FontTypeCheckListHeaderTitle:
		case FontTypeTitleBarButtons:			return [UIFont fontWithName: kDefaultFont size: 17];
		case FontTypeCheckListCellDescription:
		case FontTypeTitleBarLogoDescription:	return [UIFont fontWithName: kDefaultFontCondensedBold size: 9];
		case FontTypeSegmentedTextControl:
		case FontTypeSegmentedTextControlSelected:	return [UIFont fontWithName: kDefaultFont size: 14];
		case FontTypeTitleBarTitle:				return [UIFont fontWithName: kDefaultFontMedium size: 17];
		default:
			break;
	}
	return nil;
}

+ (UIColor *) fontColorForType: (FontType) fontType {
	switch (fontType) {
		case FontTypeCheckCardDescription:
		case FontTypeCheckCardTitle:
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
