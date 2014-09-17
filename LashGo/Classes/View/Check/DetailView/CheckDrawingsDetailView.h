//
//  CheckDrawingsDetailView.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 17.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(ushort, CheckDetailType) {
	CheckDetailTypeOpen,
	CheckDetailTypeVote,
	CheckDetailTypeClosed
};

@interface CheckDrawingsDetailView : UIView

@property (nonatomic, assign) BOOL displayPreview;
///By default, CheckDetailTypeClosed
@property (nonatomic, assign) CheckDetailType type;
@property (nonatomic, readonly) CGFloat imageCaps;
@property (nonatomic, readonly) CGFloat progressLineWidth;
@property (nonatomic, assign) CGFloat progressValue;

- (instancetype) initWithFrame: (CGRect) frame
					 imageCaps: (CGFloat) imageCaps
			 progressLineWidth: (CGFloat) progressLineWidth;

- (void) refresh;

@end
