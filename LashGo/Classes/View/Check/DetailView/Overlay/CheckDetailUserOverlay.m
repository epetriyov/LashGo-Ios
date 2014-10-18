//
//  CheckDetailUserOverlay.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckDetailUserOverlay.h"

@implementation CheckDetailUserOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) mainButtonAction: (id) sender {
	[self.delegate overlay: self action: CheckDetailOverlayActionUserImageTapped];
}

@end
