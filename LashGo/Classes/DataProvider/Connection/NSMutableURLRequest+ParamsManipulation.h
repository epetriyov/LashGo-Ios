//
//  NSMutableURLRequest+ParamsManipulation.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 19.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

typedef enum {
	URLConnectionTypeGET = 0,
	URLConnectionTypePOST = 1,
	URLConnectionTypePUT = 2,
	URLConnectionTypeDELETE = 3,
	URLConnectionTypeMULTIPART
} URLConnectionType;

@interface NSMutableURLRequest (ParamsManipulation)

+ (NSMutableURLRequest *) requestWithURL: (NSString *) url
									type: (URLConnectionType) theType
							   getParams: (NSDictionary *) getParams
							  postParams: (NSDictionary *) postParams
							headerParams: (NSDictionary *) headerParams;
+ (NSMutableURLRequest *) requestMultipartWithURL: (NSString *) url
									 headerParams: (NSDictionary *) headerParams
										paramName: (NSString *) paramName
										paramData: (NSData *) paramData fileName:(NSString *)name;

- (void) addValue: (NSString *) value forQueryParameter: (NSString *) name;

@end
