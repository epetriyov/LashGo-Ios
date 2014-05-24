//
//  LGContent.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGContent : NSObject {
	NSDate *createDate;
	NSString *text;
}

@property (nonatomic, retain) NSDate *createDate;
@property (nonatomic, retain) NSString *text;

@end
