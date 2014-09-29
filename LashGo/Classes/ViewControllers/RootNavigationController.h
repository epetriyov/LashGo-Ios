//
//  RootNavigationController.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 23.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

@interface RootNavigationController : UINavigationController <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

- (void) addWaitViewControllerOfClass: (Class) vcClass;
- (void) removeWaitViewControllerOfClass: (Class) vcClass;

@end
