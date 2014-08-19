//
//  NSDateFormatter+CustomFormats.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 12.02.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (CustomFormats)

+ (NSDateFormatter *) dateFormatterWithFullDateFormat;
+ (NSDateFormatter *) dateFormatterWithDateOnlyFormat;

@end
