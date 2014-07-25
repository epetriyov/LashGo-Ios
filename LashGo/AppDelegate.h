//
//  AppDelegate.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kernel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
	Kernel *kernel;
}

@property (strong, nonatomic) UIWindow *window;

- (void)setNetworkActivityIndicatorVisible:(BOOL) value;

@end
