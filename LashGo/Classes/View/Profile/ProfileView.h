//
//  ProfileView.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGUser.h"

@interface ProfileView : UIView

@property (nonatomic, readonly) UIButton *subscribersButton;
@property (nonatomic, readonly) UIButton *subscriptionsButton;

- (void) setUserData: (LGUser *) user;

@end
