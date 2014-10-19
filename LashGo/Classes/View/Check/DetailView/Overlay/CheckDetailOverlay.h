//
//  CheckDetailOverlay.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

typedef NS_ENUM(ushort, CheckDetailOverlayAction) {
	CheckDetailOverlayActionCheckTapped,
	CheckDetailOverlayActionUserImageTapped,
	CheckDetailOverlayActionSendUserImageTapped,
	CheckDetailOverlayActionWinnerImageTapped
};

@protocol CheckDetailOverlayDelegate;

@interface CheckDetailOverlay : UIView {
	UIButton *_mainButton;
}

@property (nonatomic, weak) id<CheckDetailOverlayDelegate> delegate;

@end

@protocol CheckDetailOverlayDelegate <NSObject>

@required
- (void) overlay: (CheckDetailOverlay *) overlay action: (CheckDetailOverlayAction) action;

@end
