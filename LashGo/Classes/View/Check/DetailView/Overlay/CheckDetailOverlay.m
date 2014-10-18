//
//  CheckDetailOverlay.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckDetailOverlay.h"

@implementation CheckDetailOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setCornerRadius: self.frame.size.width / 2];
        [self.layer setMasksToBounds:YES];
		
		_mainButton = [[UIButton alloc] initWithFrame: self.bounds];
		[_mainButton addTarget: self action: @selector(mainButtonAction:)
			  forControlEvents: UIControlEventTouchUpInside];
		[self addSubview: _mainButton];
    }
    return self;
}

- (void) mainButtonAction: (id) sender {
	
}

@end
