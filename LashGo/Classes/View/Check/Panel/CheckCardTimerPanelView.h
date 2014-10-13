//
//  CheckCardTimerPanelView.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(ushort, CheckCardTimerPanelMode) {
	CheckCardTimerPanelModeLight,
	CheckCardTimerPanelModeDark
};

@interface CheckCardTimerPanelView : UIView

@property (nonatomic, assign) CheckCardTimerPanelMode mode;
@property (nonatomic, assign) NSTimeInterval timeLeft;

- (instancetype) initWithFrame:(CGRect)frame mode:(CheckCardTimerPanelMode) mode;

@end
