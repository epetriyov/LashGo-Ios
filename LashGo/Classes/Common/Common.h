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

typedef NS_ENUM(ushort, PluralFormType) {
	PluralFormTypeOne,
	PluralFormTypeFew,
	PluralFormTypeMany
};

@interface Common : NSObject

+ (NSString *) appBuild;
+ (NSString *) appVersion;

+ (NSString *) deviceUUID;
+ (NSString *) generateUUID;
+ (NSString *) generateUniqueString;

+ (NSURL *) imageLoadingURLForName: (NSString *) name;

+ (BOOL) is568hMode;
+ (BOOL) isEmptyString: (NSString *) string;

PluralFormType pluralForm(int32_t number);
+ (NSString *) pluralSuffix: (int32_t) number;

+ (UIImage *) generateThumbnailForImage: (UIImage *) image withSize: (CGSize) size;
+ (UIImage *) generateThumbnailForImage: (UIImage *) image withSize: (CGSize) size gradient: (BOOL) gradient;

+ (void) logScaleAndParamsForTwoSizes: (float) in1 and: (float) in2;

@end
