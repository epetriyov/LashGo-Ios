//
//  ImagePickManager.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

@class Kernel;
@class ViewControllersManager;

@class LGCheck;

@interface ImagePickManager : NSObject

- (instancetype) initWithKernel: (Kernel *) kernel
					  vcManager: (ViewControllersManager *) vcManager;

- (BOOL) takePictureFor: (LGCheck *) check;

@end
