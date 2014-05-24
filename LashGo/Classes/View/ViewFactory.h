
@interface ViewFactory : NSObject {
	UIImage *titleBarBackgroundImage;
	UIImage *titleBarLogoImage;
}

@property (nonatomic, readonly) UIColor *statusBarPreferredColor;
@property (nonatomic, readonly) UIImage *titleBarBackgroundImage;
@property (nonatomic, readonly) UIImage *titleBarLogoImage;

+ (ViewFactory *) sharedFactory;

- (UIImage *) getImageWithName: (NSString *) imageName;
- (UIButton *) buttonWithBGImageName:(NSString *) imageName target: (id) target action: (SEL) selector;

//Title bar
- (UIButton *) titleBarBackButtonWithTarget: (id) target action: (SEL) selector;
- (UIButton *) titleBarRightButtonWithText: (NSString *) text target: (id) target action: (SEL) selector;

@end