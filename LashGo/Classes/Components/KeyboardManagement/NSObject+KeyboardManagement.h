//
//  NSObject+KeyboardManagement.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 10.03.15.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ScrollableEditableContentProtocol.h"

@interface NSObject (KeyboardManagement) <ScrollableEditableContentProtocol>

- (void)keyboardWillBeShown: (NSNotification*) aNotification;
- (void)keyboardDidShown: (NSNotification*) aNotification;
- (void)keyboardWillBeHidden: (NSNotification*) aNotification;

@end
