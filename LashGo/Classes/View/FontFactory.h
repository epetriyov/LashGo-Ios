
typedef enum {
	FontTypeTitleBarButtons = 0,
	FontTypeTitleBarLogoDescription,
	FontTypeTitleBarTitle,
} FontType;

@interface FontFactory : NSObject

+ (UIFont *) fontWithType: (FontType) fontType;
+ (UIColor *) fontColorForType: (FontType) fontType;
+ (UIColor *) fontShadownColorForType: (FontType) fontType;

@end