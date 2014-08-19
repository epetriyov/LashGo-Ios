//
//  NSDateFormatter+CustomFormats.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 12.02.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "NSDateFormatter+CustomFormats.h"

@implementation NSDateFormatter (CustomFormats)

+ (NSCache *) sharedCache {
    static dispatch_once_t onceToken;
    static NSCache *sharedCache = nil;
    dispatch_once(&onceToken, ^{
        sharedCache = [[NSCache alloc] init];
    });
    return sharedCache;
}

+ (NSDateFormatter *) customDateFormatterWithFormat: (NSString *) format {
    NSDateFormatter *dateFormatter = [[self sharedCache] objectForKey:format];
    if(dateFormatter==nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.locale = [NSLocale localeWithLocaleIdentifier: @"en_US_POSIX"];
		[dateFormatter setDateFormat: format];
        [[self sharedCache] setObject: dateFormatter forKey:format];
    }
    return dateFormatter;
}

+ (NSDateFormatter *) dateFormatterWithFullDateFormat {
	return [self customDateFormatterWithFormat: @"yyyy-MM-dd HH:mm:ss.SSS Z"];
}

+ (NSDateFormatter *) dateFormatterWithDateOnlyFormat {
	return [self customDateFormatterWithFormat: @"yyyy-MM-dd"];
}

@end
