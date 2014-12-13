
typedef NS_ENUM(NSInteger, FontType) {
	FontTypeCheckCardDescription,
	FontTypeCheckCardTitle,
	FontTypeCheckDetailWinnerFIO,
	FontTypeCheckListCellTitle,
	FontTypeCheckListCellDescription,
	FontTypeCheckListHeaderTitle,
	FontTypeCheckPhotosWinnerTitle,
	FontTypeCountersTitle,
	FontTypeCountersDarkTitle,
	FontTypeLoginActionBtnTitle,
	FontTypeLoginInputField,
	FontTypeLoginRestorePass,
	FontTypeLoginSocialLabel,
	FontTypeLoginWelcomeText,
	FontTypeProfileFIO,
	FontTypeProfileLabels,
	FontTypeProfileLabelsCount,
	FontTypeProfileLabelsFollowCount,
	FontTypePullToRefreshTitle,
	FontTypeSegmentedTextControl,
	FontTypeSegmentedTextControlSelected,
	FontTypeSlogan,
	FontTypeStartScreenButtons,
	FontTypeSubscriptionTitle,
	FontTypeTaskbarButtons,
	FontTypeTitleBarButtons,
	FontTypeTitleBarLogoDescription,
	FontTypeTitleBarTitle,
	FontTypeUserChangeAvatarTitle,
	FontTypeVoteCheckTitle,
	FontTypeVoteCheckDescription,
	FontTypeVotePager,
	FontTypeVoteTimer
};

@interface FontFactory : NSObject

+ (UIFont *) fontWithType: (FontType) fontType;
+ (UIColor *) fontColorForType: (FontType) fontType;
+ (UIColor *) fontShadownColorForType: (FontType) fontType;

@end