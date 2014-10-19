//
//  CheckDetailView.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 08.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CircleGradientLayer.h"
#import "CheckDrawingsDetailView.h"

#import "LGCheck.h"

@protocol CheckDetailViewDelegate;

@interface CheckDetailView : UIView

@property (nonatomic, weak) id<CheckDetailViewDelegate> delegate;

@property (nonatomic, assign) BOOL displayPreview;
///By default, CheckDetailTypeClosed
@property (nonatomic, assign) CheckDetailType type;
@property (nonatomic, readonly) CGFloat imageCaps;
@property (nonatomic, readonly) CGFloat progressLineWidth;
@property (nonatomic, assign) CGFloat progressValue;

- (instancetype) initWithFrame: (CGRect) frame
					 imageCaps: (CGFloat) imageCaps
			 progressLineWidth: (CGFloat) progressLineWidth;

- (void) setImageWithURLString: (NSString *) url;
- (void) setUserImagesWithCheck: (LGCheck *) check;
- (void) setUserImageWithImage: (UIImage *) image;
- (void) setUserImageWithURLString: (NSString *) url;
///Refresh buttons and drawings, images and overlays should be refreshed manually
- (void) refresh;

@end

@protocol CheckDetailViewDelegate <NSObject>

@required
- (void) makePhotoAction;
- (void) voteAction;
- (void) imageAction;
- (void) userImageAction;
- (void) sendUserImageAction;
- (void) winnerImageAction;

@end
