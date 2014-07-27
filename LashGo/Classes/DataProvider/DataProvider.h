//
//  DataProvider.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGLoginInfo.h"

@interface DataProvider : NSObject

- (void) registerUser: (LGLoginInfo *) inputData;

@end
