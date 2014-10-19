//
//  CheckDetailUserOverlay.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckDetailUserOverlay.h"

#import "Common.h"
#import "FontFactory.h"
#import "ViewFactory.h"
#import "UIView+CGExtension.h"

@implementation CheckDetailUserOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		UIView *darkPanel = [[UIView alloc] initWithFrame: self.bounds];
		darkPanel.backgroundColor = [UIColor colorWithWhite: 0 alpha: 128.0/255.0];
		[self addSubview:darkPanel];
		
		[self bringSubviewToFront: _mainButton];
		
		//Bottom to top
		
		UIButton *sendButton = [[ViewFactory sharedFactory] checkSendFoto: self action: @selector(sendButtonAction:)];
		float offsetY = self.frame.size.height - sendButton.frame.size.height + 7;
		sendButton.frameY = offsetY;
		sendButton.centerX = self.frame.size.width / 2;
		[self addSubview: sendButton];
		
		UILabel *textLabel = [[UILabel alloc] init];
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.font = [FontFactory fontWithType: FontTypeCheckDetailWinnerFIO];
		textLabel.text = @"ChecksSendUserImageTitle".commonLocalizedString;
		textLabel.textAlignment = NSTextAlignmentCenter;
		textLabel.textColor = [FontFactory fontColorForType: FontTypeCheckDetailWinnerFIO];
		[textLabel sizeToFit];
		offsetY -= textLabel.frame.size.height;
		textLabel.frameY = offsetY;
		textLabel.centerX = sendButton.center.x;
		[self addSubview: textLabel];
		
    }
    return self;
}

- (void) sendButtonAction: (id) sender {
	[self.delegate overlay: self action: CheckDetailOverlayActionSendUserImageTapped];
}

- (void) mainButtonAction: (id) sender {
	[self.delegate overlay: self action: CheckDetailOverlayActionUserImageTapped];
}

@end
