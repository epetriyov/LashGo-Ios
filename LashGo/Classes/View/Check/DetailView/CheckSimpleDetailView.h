//
//  CheckSimpleDetailView.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 27.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CircleGradientLayer.h"
#import "CheckDrawingsDetailView.h"

@interface CheckSimpleDetailView : UIView

@property (nonatomic, assign) BOOL displayPreview;
///By default, CheckDetailTypeClosed
@property (nonatomic, assign) CheckDetailType type;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) CGFloat imageCaps;
@property (nonatomic, readonly) CGFloat progressLineWidth;
@property (nonatomic, assign) CGFloat progressValue;

- (instancetype) initWithFrame: (CGRect) frame
					 imageCaps: (CGFloat) imageCaps
			 progressLineWidth: (CGFloat) progressLineWidth;

- (void) refresh;

@end
