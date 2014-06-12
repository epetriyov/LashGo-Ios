//
//  Singleton.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 12.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#define SHARED_INSTANCE_WITH_BLOCK(block) \
static dispatch_once_t pred = 0; \
static id __strong _sharedObject = nil; \
dispatch_once(&pred, ^{ \
	_sharedObject = block(); \
}); \
return _sharedObject; \
