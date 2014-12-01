
@interface ViewFactory : NSObject {
	UIImage *titleBarBackgroundImage;
	UIImage *titleBarLogoImage;
}

@property (nonatomic, readonly) UIImage *checkDetailWinnerLed;
@property (nonatomic, readonly) UIImage *checkDetailWinnerMedal;
@property (nonatomic, readonly) UIImage *gradientPhotoTopImage;
@property (nonatomic, readonly) UIImage *gradientPhotoBottomImage;
@property (nonatomic, readonly) UIImage *iconEmail;
@property (nonatomic, readonly) UIImage *iconPassword;
@property (nonatomic, readonly) UIImage *lgLogoImage;
@property (nonatomic, readonly) UIImage *loginViewControllerBgImage;
@property (nonatomic, readonly) UIImage *startViewControllerBgImage;
@property (nonatomic, readonly) UIImage *startViewControllerFrameImage;
@property (nonatomic, readonly) UIImage *startViewControllerGradientImage;
@property (nonatomic, readonly) UIColor *statusBarPreferredColor;
@property (nonatomic, readonly) UIButton *subscribeCellButton;
@property (nonatomic, readonly) UIView *taskbarBackgroundView;
@property (nonatomic, readonly) UIView *taskbarLightBackgroundView;
@property (nonatomic, readonly) UIImage *timerCheckOpenImage;
@property (nonatomic, readonly) UIImage *titleBarAvatarPlaceholder;
@property (nonatomic, readonly) UIImage *titleBarBackgroundImage;
@property (nonatomic, readonly) UIImage *titleBarLogoImage;
@property (nonatomic, readonly) UIImage *userProfileAvatarPlaceholder;

+ (ViewFactory *) sharedFactory;

- (UIImage *) getImageWithName: (NSString *) imageName;
- (UIButton *) buttonWithBGImageName:(NSString *) imageName target: (id) target action: (SEL) selector;

//Check
- (UIButton *) checkMakeFoto: (id) target action: (SEL) selector;
- (UIButton *) checkSendFoto: (id) target action: (SEL) selector;
- (UIButton *) checkVote: (id) target action: (SEL) selector;

//Counters
- (UIButton *) counterComment: (id) target action: (SEL) selector;
- (UIButton *) counterCommentDark: (id) target action: (SEL) selector;
- (UIButton *) counterLike: (id) target action: (SEL) selector;
- (UIButton *) counterLikeDark: (id) target action: (SEL) selector;
- (UIButton *) counterMob: (id) target action: (SEL) selector;
- (UIButton *) counterMobDark: (id) target action: (SEL) selector;
- (UIButton *) counterShare: (id) target action: (SEL) selector;
- (UIButton *) counterShareDark: (id) target action: (SEL) selector;

//Login
- (UIButton *) loginButtonWithTarget: (id) target action: (SEL) selector;
- (UIButton *) loginFacebookButtonWithTarget: (id) target action: (SEL) selector;
- (UIButton *) loginTwitterButtonWithTarget: (id) target action: (SEL) selector;
- (UIButton *) loginVkontakteButtonWithTarget: (id) target action: (SEL) selector;

//Title bar
- (UIButton *) titleBarBackButtonWithTarget: (id) target action: (SEL) selector;
- (UIButton *) titleBarCameraButtonWithTarget: (id) target action: (SEL) selector;
- (UIButton *) titleBarCheckCardsButtonWithTarget: (id) target action: (SEL) selector;
- (UIButton *) titleBarCheckListButtonWithTarget: (id) target action: (SEL) selector;
- (UIButton *) titleBarIconButtonWithTarget: (id) target action: (SEL) selector;
- (UIButton *) titleBarRightButtonWithText: (NSString *) text target: (id) target action: (SEL) selector;
- (UIButton *) titleBarRightIncomeButtonWithTarget: (id) target action: (SEL) selector;
- (UIButton *) titleBarRightSearchButtonWithTarget: (id) target action: (SEL) selector;
- (UIButton *) titleBarSendPhotoButtonWithTarget: (id) target action: (SEL) selector;

//User
- (UIButton *) userChangeAvatarButtonWithTarget: (id) target action: (SEL) selector;
- (UIButton *) userEditButtonWithTarget:(id)target action:(SEL)selector;
- (UIButton *) userFollowWhiteButtonWithTarget:(id)target action:(SEL)selector;

//Vote
- (UIButton *) votePhotoSelectButtonWithIndex: (ushort) index target: (id) target action: (SEL) selector;
- (UIButton *) votePhotoLikeButtonWithTarget: (id) target action: (SEL) selector;
- (UIButton *) votePhotoNextButtonWithTarget: (id) target action: (SEL) selector;

@end
