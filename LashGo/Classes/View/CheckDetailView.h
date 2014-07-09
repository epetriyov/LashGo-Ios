//
//  CheckDetailView.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 08.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

NS_ENUM(ushort, CheckDetailType) {
	CheckDetailTypeOpen,
	CheckDetailTypeVote,
	CheckDetailTypeClosed
};

@interface CheckDetailView : UIView {
	CAShapeLayer *_arcLayer;
}

@property (nonatomic, assign) enum CheckDetailType type;
@property (nonatomic, strong) UIImage *image;

@end
