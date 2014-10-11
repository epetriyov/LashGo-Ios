//
//  CheckDetailView.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 08.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CircleGradientLayer.h"
#import "CheckDrawingsDetailView.h"

@protocol CheckDetailViewDelegate;

@interface CheckDetailView : UIView

@property (nonatomic, weak) id<CheckDetailViewDelegate> delegate;

@property (nonatomic, assign) BOOL displayPreview;
///By default, CheckDetailTypeClosed
@property (nonatomic, assign) CheckDetailType type;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, strong) UIImage *userImage;
@property (nonatomic, readonly) CGFloat imageCaps;
@property (nonatomic, readonly) CGFloat progressLineWidth;
@property (nonatomic, assign) CGFloat progressValue;

- (instancetype) initWithFrame: (CGRect) frame
					 imageCaps: (CGFloat) imageCaps
			 progressLineWidth: (CGFloat) progressLineWidth;

- (void) refresh;

@end

@protocol CheckDetailViewDelegate <NSObject>

@required
- (void) makePhotoAction;
- (void) voteAction;
- (void) imageAction;
- (void) userImageAction;

@end
