//
//  VotePanelView.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 25.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(ushort, VotePanelType) {
	VotePanelTypeLike = 0,
	VotePanelTypeNext
};

@interface VotePanelView : UIView

@property (nonatomic, assign) VotePanelType type;
@property (nonatomic, readonly) UIImageView *photo0ImageView;
@property (nonatomic, readonly) UIImageView *photo1ImageView;
@property (nonatomic, readonly) UIImageView *photo2ImageView;
@property (nonatomic, readonly) UIImageView *photo3ImageView;

@end