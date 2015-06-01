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

+ (NSDateFormatter *) customDateFormatterWithKey: (NSString *) format
										  initBlock: (NSDateFormatter *(^)(void)) initBlock {
	NSDateFormatter *dateFormatter = [[self sharedCache] objectForKey:format];
	if(dateFormatter==nil) {
		dateFormatter = initBlock();
		[[self sharedCache] setObject: dateFormatter forKey:format];
	}
	return dateFormatter;
}

+ (NSDateFormatter *) customDateFormatterWithFormat: (NSString *) format {
	NSDateFormatter *dateFormatter = [[self sharedCache] objectForKey:format];
	if(dateFormatter==nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat: format];
		[[self sharedCache] setObject: dateFormatter forKey:format];
	}
	return dateFormatter;
}

+ (NSDateFormatter *) displayDateFormatterWithFormat: (NSString *) format {
	NSDateFormatter *dateFormatter = [self customDateFormatterWithFormat: format];
	dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
	return dateFormatter;
}

+ (NSDateFormatter *) parseDateFormatterWithFormat: (NSString *) format {
	NSDateFormatter *dateFormatter = [self customDateFormatterWithFormat: format];
	dateFormatter.locale = [NSLocale localeWithLocaleIdentifier: @"en_US_POSIX"];
	return dateFormatter;
}

+ (NSDateFormatter *) dateFormatterWithFullDateFormat {
	return [self parseDateFormatterWithFormat: @"dd.MM.yyyy HH:mm:ss Z"];
}

+ (NSDateFormatter *) dateFormatterWithDateOnlyFormat {
	return [self parseDateFormatterWithFormat: @"dd.MM.yyyy"];
}

+ (NSDateFormatter *) dateFormatterWithHistoryPeriodPickerShortFormat {
	return [self parseDateFormatterWithFormat: @"dd.MM"];
}

+ (NSDateFormatter *) dateFormatterWithDisplayShortDateFormat {
	return [self customDateFormatterWithKey: @"system:dd/MM/yyyy" initBlock:^NSDateFormatter *{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
		dateFormatter.dateStyle = NSDateFormatterShortStyle;
		dateFormatter.timeStyle = NSDateFormatterNoStyle;
		return dateFormatter;
	}];
}

+ (NSDateFormatter *) dateFormatterWithDisplayShortDateAndTimeFormat {
	return [self customDateFormatterWithKey: @"system:dd/MM/yyyy HH:mm" initBlock:^NSDateFormatter *{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
		dateFormatter.dateStyle = NSDateFormatterShortStyle;
		dateFormatter.timeStyle = NSDateFormatterShortStyle;
		return dateFormatter;
	}];
}

+ (NSDateFormatter *) dateFormatterWithDisplayMediumDateFormat {
	return [self customDateFormatterWithKey: @"system:dd MMM yyyy" initBlock:^NSDateFormatter *{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
		dateFormatter.dateStyle = NSDateFormatterMediumStyle;
		dateFormatter.timeStyle = NSDateFormatterNoStyle;
		return dateFormatter;
	}];
}

+ (NSDateFormatter *) dateFormatterWithDisplayLongDateFormat {
	return [self customDateFormatterWithKey: @"system:dd MMMM yyyy" initBlock:^NSDateFormatter *{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
		dateFormatter.dateStyle = NSDateFormatterLongStyle;
		dateFormatter.timeStyle = NSDateFormatterNoStyle;
		return dateFormatter;
	}];
}

+ (NSDateFormatter *) dateFormatterWithDisplayTimeShortFormat {
	return [self customDateFormatterWithKey: @"system:HH:mm" initBlock:^NSDateFormatter *{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
		dateFormatter.dateStyle = NSDateFormatterNoStyle;
		dateFormatter.timeStyle = NSDateFormatterShortStyle;
		return dateFormatter;
	}];
}

+ (NSDateFormatter *) dateFormatterWithTimeHourOnly {
	return [self parseDateFormatterWithFormat: @"HH"];
}

@end
