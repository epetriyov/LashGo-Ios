//
//  ContextualArrayResult.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 13.12.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContextualArrayResult : NSObject

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) id context;

@end
