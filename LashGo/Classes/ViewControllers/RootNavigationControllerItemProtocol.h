//
//  RootNavigationControllerItemProtocol.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 13.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RootNavigationControllerItemProtocol <NSObject>

@required
@property (nonatomic, assign) BOOL canGoBack;
@property (nonatomic, assign, getter = isWaitViewHidden) BOOL waitViewHidden;

@end
