//
//  NSMutableURLRequest+ParamsManipulation.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "NSMutableURLRequest+ParamsManipulation.h"
#import "Common.h"

@implementation NSMutableURLRequest (ParamsManipulation)

+ (NSMutableURLRequest *) requestWithURL: (NSString *) url
									type: (URLConnectionType) theType
							   getParams: (NSDictionary *) getParams
							  postParams: (NSDictionary *) postParams
							headerParams: (NSDictionary *) headerParams {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
	
	switch (theType) {
		case URLConnectionTypePOST:
			[request setHTTPMethod: @"POST"];
			break;
		case URLConnectionTypePUT:
			[request setHTTPMethod: @"PUT"];
			break;
		case URLConnectionTypeDELETE:
			[request setHTTPMethod: @"DELETE"];
			break;
		default:
			[request setHTTPMethod: @"GET"];
			break;
	}
	
	[request setAllHTTPHeaderFields: headerParams];
	if ((theType == URLConnectionTypePOST || theType == URLConnectionTypePUT)
		&& postParams != nil && postParams.count > 0) {
		[request setValue: [NSString stringWithFormat: @"application/x-www-form-urlencoded"]
	   forHTTPHeaderField: @"Content-Type"];
		NSString *postParamsString = [self getParamStringFrom: postParams];
		[request setPostParameters: postParamsString];
	}
	
	NSString *getParamsString = [self getParamStringFrom: getParams];
	if ([Common stringIsEmpty: getParamsString] == NO) {
		[request setGetParameters: getParamsString];
	}
	
	return request;
}

+ (NSString *) getParamStringFrom: (NSDictionary *) params {
	if (params == nil || params.count <= 0) {
		return nil;
	}
	
	NSMutableString *resultString = [NSMutableString string];
	
	for (NSString* paramName in [params allKeys]) {
		id paramValue = [params valueForKey: paramName];
		if ([paramValue isKindOfClass: [NSString class]] == YES) {
//			paramValue = [paramValue stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//			paramName = [paramName stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
			
			if (resultString.length > 0) {
				[resultString appendString: @"&"];
			}
			[resultString appendFormat: @"%@=%@", paramName, paramValue];
		}
	}
	return resultString;
}

- (void) setPostParameters: (NSString *) paramsString {
	[self setHTTPBody: [paramsString dataUsingEncoding: NSUTF8StringEncoding]];
}

- (void) setGetParameters: (NSString *) paramsString {
	NSString *url = [self.URL absoluteString];
	if ([url rangeOfString: @"?"].location == NSNotFound) {
		url = [url stringByAppendingFormat: @"?%@", paramsString];
	} else {
		url = [url stringByAppendingFormat: @"&%@", paramsString];
	}
	[self setURL: [NSURL URLWithString: url]];
}

- (void) addValue: (NSString *) value forQueryParameter: (NSString *) name {
	value = [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	name = [name stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	NSString *url = [self.URL absoluteString];
	if ([url rangeOfString: @"?"].location == NSNotFound) {
		url = [url stringByAppendingFormat: @"?%@=%@", name, value];
	} else {
		url = [url stringByAppendingFormat: @"&%@=%@", name, value];
	}
	[self setURL: [NSURL URLWithString: url]];
}

@end