//
//  Kernel.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ViewControllersManager.h"

@interface Kernel : NSObject {
	ViewControllersManager *viewControllersManager;
}

@property (nonatomic, readonly) UIViewController *rootViewController;
@property (nonatomic, readonly) ViewControllersManager *viewControllersManager;

@end
