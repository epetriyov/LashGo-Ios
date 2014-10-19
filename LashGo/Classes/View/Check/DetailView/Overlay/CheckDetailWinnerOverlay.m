//
//  CheckDetailWinnerOverlay.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckDetailWinnerOverlay.h"

#import "FontFactory.h"
#import "ViewFactory.h"

@implementation CheckDetailWinnerOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		float panelHeight = self.frame.size.height * 0.26;
		
		UIView *darkPanel = [[UIView alloc] initWithFrame: CGRectMake(0, self.frame.size.height - panelHeight,
																	  self.frame.size.width, panelHeight)];
		darkPanel.backgroundColor = [UIColor colorWithWhite: 0 alpha: 128.0/255.0];
		[self addSubview:darkPanel];
		
		UIImageView *ledImageView = [[UIImageView alloc] initWithImage:
									 [ViewFactory sharedFactory].checkDetailWinnerLed];
		ledImageView.center = CGPointMake(darkPanel.frame.size.width / 2, darkPanel.frame.origin.y);
		[self addSubview: ledImageView];
		
		_fio = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width * 0.65, panelHeight / 3)];
		_fio.adjustsFontSizeToFitWidth = YES;
		_fio.backgroundColor = [UIColor clearColor];
		_fio.center = darkPanel.center;
		_fio.font = [FontFactory fontWithType: FontTypeCheckDetailWinnerFIO];
		_fio.textAlignment = NSTextAlignmentCenter;
		_fio.textColor = [FontFactory fontColorForType: FontTypeCheckDetailWinnerFIO];
		[self addSubview: _fio];
		
		[self bringSubviewToFront: _mainButton];
    }
    return self;
}

- (void) mainButtonAction: (id) sender {
	[self.delegate overlay: self action: CheckDetailOverlayActionUserImageTapped];
}

@end
