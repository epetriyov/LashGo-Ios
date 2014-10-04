
typedef NS_ENUM(NSInteger, FontType) {
	FontTypeCheckCardDescription,
	FontTypeCheckCardTitle,
	FontTypeCheckListCellTitle,
	FontTypeCheckListCellDescription,
	FontTypeCheckListHeaderTitle,
	FontTypeLoginActionBtnTitle,
	FontTypeLoginInputField,
	FontTypeLoginRestorePass,
	FontTypeLoginSocialLabel,
	FontTypeLoginWelcomeText,
	FontTypeSegmentedTextControl,
	FontTypeSegmentedTextControlSelected,
	FontTypeSlogan,
	FontTypeStartScreenButtons,
	FontTypeTaskbarButtons,
	FontTypeTitleBarButtons,
	FontTypeTitleBarLogoDescription,
	FontTypeTitleBarTitle,
	FontTypeUserChangeAvatarTitle,
	FontTypeVoteCheckTitle,
	FontTypeVoteCheckDescription,
	FontTypeVoteTimer
};

@interface FontFactory : NSObject

+ (UIFont *) fontWithType: (FontType) fontType;
+ (UIColor *) fontColorForType: (FontType) fontType;
+ (UIColor *) fontShadownColorForType: (FontType) fontType;

@end