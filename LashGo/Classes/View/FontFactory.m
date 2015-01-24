
#import "FontFactory.h"

#define kDefaultFont				@"HelveticaNeue"
#define kDefaultFontBold			@"HelveticaNeue-Bold"
#define kDefaultFontCondensedBold	@"HelveticaNeue-CondensedBold"
#define kDefaultFontLight			@"HelveticaNeue-Light"
#define kDefaultFontMedium			@"HelveticaNeue-Medium"

@implementation FontFactory

+ (UIFont *) fontWithType: (FontType) fontType {
	switch (fontType) {
		case FontTypeCheckCardDescription:
		case FontTypeCheckPhotosWinnerTitle:	return [UIFont fontWithName: kDefaultFontMedium size: 16];
		case FontTypeCheckCardTitle:			return [UIFont fontWithName: kDefaultFont size: 20];
		case FontTypeCheckListCellTitle:		return [UIFont fontWithName: kDefaultFontBold size: 14];
		case FontTypeCheckListCellDescription:
		case FontTypeCommentsCellDate:
		case FontTypeCommentsCellDescription:
		case FontTypePullToRefreshTitle:		return [UIFont fontWithName: kDefaultFont size: 12];
		case FontTypeCommentsCellTitle:			return [UIFont fontWithName: kDefaultFontMedium size: 13];
		case FontTypeCountersTitle:
		case FontTypeCountersDarkTitle:			return [UIFont fontWithName: kDefaultFontMedium size: 10];
		case FontTypeLoginActionBtnTitle:		return [UIFont fontWithName: kDefaultFontMedium size: 18];
		case FontTypeLoginInputField:			return [UIFont fontWithName: kDefaultFontLight size: 17];
		case FontTypeLoginLicense:				return [UIFont fontWithName: kDefaultFontBold size: 13];
		case FontTypeProfileFIO:				return [UIFont fontWithName: kDefaultFontMedium size: 21];
		case FontTypeProfileLabels:				return [UIFont fontWithName: kDefaultFont size: 12];
		case FontTypeProfileLabelsCount:		return [UIFont fontWithName: kDefaultFont size: 14];
		case FontTypeProfileLabelsFollowCount:	return [UIFont fontWithName: kDefaultFont size: 19];
		case FontTypeLoginRestorePass:
		case FontTypeVoteCheckDescription:		return [UIFont fontWithName: kDefaultFont size: 13];
		case FontTypeLoginSocialLabel:
		case FontTypeUserChangeAvatarTitle:
		case FontTypeVotePager:					return [UIFont fontWithName: kDefaultFont size: 15];
		case FontTypeLoginWelcomeText:			return [UIFont fontWithName: kDefaultFontLight size: 24];
		case FontTypeTaskbarButtons:			return [UIFont fontWithName: kDefaultFont size: 10];
		case FontTypeTitleBarButtons:			return [UIFont fontWithName: kDefaultFont size: 17];
		case FontTypeTitleBarLogoDescription:	return [UIFont fontWithName: kDefaultFontCondensedBold size: 9];
		case FontTypeCheckListHeaderTitle:
		case FontTypeSegmentedTextControl:
		case FontTypeSegmentedTextControlSelected:	return [UIFont fontWithName: kDefaultFont size: 14];
		case FontTypeSlogan:					return [UIFont fontWithName: kDefaultFont size: 24];
		case FontTypeCheckDetailWinnerFIO:
		case FontTypeStartScreenButtons:		return [UIFont fontWithName: kDefaultFontMedium size: 12];
		case FontTypeSubscriptionTitle:			return [UIFont fontWithName: kDefaultFont size: 16];
		case FontTypeTitleBarTitle:				return [UIFont fontWithName: kDefaultFontMedium size: 17];
		case FontTypeVoteCheckTitle:			return [UIFont fontWithName: kDefaultFontMedium size: 15];
		case FontTypeVoteTimer:					return [UIFont fontWithName: kDefaultFontMedium size: 14];
		default:
			break;
	}
	return nil;
}

+ (UIColor *) fontColorForType: (FontType) fontType {
	switch (fontType) {
		case FontTypeCheckCardDescription:	return [UIColor colorWithWhite: 1.0 alpha: 128.0/255.0];
		case FontTypeCheckCardTitle:		return [UIColor colorWithWhite: 1.0 alpha: 204.0/255.0];
		case FontTypeCommentsCellDescription:
		case FontTypeCountersDarkTitle:		return [UIColor colorWithWhite: 114.0/255.0 alpha: 1.0];//same as B2 0(178)
		case FontTypeTaskbarButtons:		return [UIColor colorWithRed:141.0/255.0
															 green:144.0/255.0
															  blue:144.0/255.0 alpha:1.0];
		case FontTypeCheckListCellTitle:
		case FontTypeCommentsCellTitle:
		case FontTypeLoginInputField:
		case FontTypeVoteCheckTitle:		return [UIColor colorWithWhite: 51.0/255.0 alpha: 1];//same as E5 0(229) alpha
		case FontTypeLoginRestorePass:
		case FontTypeLoginSocialLabel:		return [UIColor colorWithWhite: 1.0 alpha: 229.0/255.0];
		case FontTypeCheckDetailWinnerFIO:
		case FontTypeCheckPhotosWinnerTitle:
		case FontTypeCountersTitle:
		case FontTypeLoginActionBtnTitle:
		case FontTypeLoginLicense:
		case FontTypeLoginWelcomeText:
		case FontTypeProfileFIO:
		case FontTypeProfileLabels:
		case FontTypeProfileLabelsCount:
		case FontTypeProfileLabelsFollowCount:
		case FontTypeStartScreenButtons:
		case FontTypeTitleBarButtons:
		case FontTypeUserChangeAvatarTitle:	return [UIColor whiteColor];
		case FontTypeCheckListCellDescription:
		case FontTypeCommentsCellDate:
		case FontTypeVoteCheckDescription:
		case FontTypeVotePager:				return [UIColor colorWithWhite: 151.0/255.0 alpha: 1];//same as 80 0(128)
		case FontTypeVoteTimer:				return [UIColor colorWithRed: 1.0 green: 94.0/255.0 blue: 124.0/255.0
														  alpha: 1.0];
		case FontTypeSubscriptionTitle:		return [UIColor colorWithWhite: 98.0/255.0 alpha: 1];//same as E5 0
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
