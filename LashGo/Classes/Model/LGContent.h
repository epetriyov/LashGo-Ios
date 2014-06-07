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

@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSString *text;

@end
