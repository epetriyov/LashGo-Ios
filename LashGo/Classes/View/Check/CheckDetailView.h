//
//  CheckDetailView.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 08.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CircleGradientLayer.h"

typedef NS_ENUM(ushort, CheckDetailType) {
	CheckDetailTypeOpen,
	CheckDetailTypeVote,
	CheckDetailTypeClosed
};

@interface CheckDetailView : UIView

@property (nonatomic, assign) BOOL displayPreview;
@property (nonatomic, assign) CheckDetailType type;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, readonly) CGFloat imageCaps;
@property (nonatomic, readonly) CGFloat progressLineWidth;
@property (nonatomic, assign) CGFloat progressValue;

- (instancetype) initWithFrame: (CGRect) frame
					 imageCaps: (CGFloat) imageCaps
			 progressLineWidth: (CGFloat) progressLineWidth;

- (void) refresh;

@end
