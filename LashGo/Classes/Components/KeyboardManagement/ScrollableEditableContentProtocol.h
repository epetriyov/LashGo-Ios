//
//  ScrollableEditableContentProtocol.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 10.03.15.
//  Copyright (c) 2015 Vitaliy Pykhtin. All rights reserved.
//

@protocol ScrollableEditableContentProtocol <NSObject>

@property (nonatomic, readonly) UIScrollView *contentScrollView;
@property (nonatomic, readonly) UIView *activeFirstResponder;

@end
