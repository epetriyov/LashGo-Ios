//
//  PhotoCountersPanelView.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.12.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCountersPanelView : UIView

@property (nonatomic, readonly) UIButton *likesButton;
@property (nonatomic, assign) int32_t likesCount;

@property (nonatomic, readonly) UIButton *commentsButton;
@property (nonatomic, assign) int32_t commentsCount;

@end
