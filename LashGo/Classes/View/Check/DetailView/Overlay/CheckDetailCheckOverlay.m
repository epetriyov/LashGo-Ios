//
//  CheckDetailCheckOverlay.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckDetailCheckOverlay.h"

@implementation CheckDetailCheckOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) mainButtonAction: (id) sender {
	[self.delegate overlay: self action: CheckDetailOverlayActionCheckTapped];
}

@end
