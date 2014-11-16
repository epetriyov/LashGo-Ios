//
//  Common.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 23.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface NSString (CommonExtension)

@property (nonatomic, readonly) NSString *commonLocalizedString;

+ (NSString *) stringWithData: (NSData *) data;
- (NSString *) stringBetweenString:(NSString*)start
						 andString:(NSString*)end;

@end

@interface Common : NSObject

+ (NSString *) appBuild;
+ (NSString *) appVersion;

+ (NSString *) deviceUUID;
+ (NSString *) generateUUID;
+ (NSString *) generateUniqueString;

+ (BOOL) is568hMode;
+ (BOOL) isEmptyString: (NSString *) string;

+ (UIImage *) generateThumbnailForImage: (UIImage *) image withSize: (CGSize) size;
+ (UIImage *) generateThumbnailForImage: (UIImage *) image withSize: (CGSize) size gradient: (BOOL) gradient;

+ (void) logScaleAndParamsForTwoSizes: (float) in1 and: (float) in2;

@end
