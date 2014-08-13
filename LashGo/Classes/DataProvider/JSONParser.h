//
//  JSONParser.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "LGCheck.h"
#import "URLConnection.h"

@interface JSONParser : NSObject

- (NSError *) parseError: (URLConnection *) connection;

- (NSArray *) parseChecks: (NSData *) jsonData;

@end
