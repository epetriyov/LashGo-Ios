//
//  NSDateFormatter+CustomFormats.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 12.02.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

@interface NSDateFormatter (CustomFormats)

+ (NSDateFormatter *) dateFormatterWithFullDateFormat;
+ (NSDateFormatter *) dateFormatterWithDateOnlyFormat;
+ (NSDateFormatter *) dateFormatterWithHistoryPeriodPickerShortFormat;
+ (NSDateFormatter *) dateFormatterWithDisplayShortDateFormat;
+ (NSDateFormatter *) dateFormatterWithDisplayShortDateAndTimeFormat;
+ (NSDateFormatter *) dateFormatterWithDisplayMediumDateFormat;
+ (NSDateFormatter *) dateFormatterWithDisplayLongDateFormat;
+ (NSDateFormatter *) dateFormatterWithDisplayTimeShortFormat;
+ (NSDateFormatter *) dateFormatterWithTimeHourOnly;

@end
