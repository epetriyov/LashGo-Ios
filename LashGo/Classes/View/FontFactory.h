
typedef NS_ENUM(NSInteger, FontType) {
	FontTypeCheckCardDescription,
	FontTypeCheckCardTitle,
	FontTypeCheckListCellTitle,
	FontTypeCheckListCellDescription,
	FontTypeCheckListHeaderTitle,
	FontTypeTitleBarButtons,
	FontTypeTitleBarLogoDescription,
	FontTypeTitleBarTitle
};

@interface FontFactory : NSObject

+ (UIFont *) fontWithType: (FontType) fontType;
+ (UIColor *) fontColorForType: (FontType) fontType;
+ (UIColor *) fontShadownColorForType: (FontType) fontType;

@end