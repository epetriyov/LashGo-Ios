//
//  Common.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 23.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CommonExtension)

+ (NSString *) stringWithData: (NSData *) data;

@end

@interface Common : NSObject

+ (NSString *) appBuild;
+ (NSString *) appVersion;

+ (NSString *) generateUUID;
+ (NSString *) generateUniqueString;

+ (BOOL) isEmpty: (NSString *) string;

@end
