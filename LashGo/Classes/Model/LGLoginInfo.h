//
//  LGLoginInfo.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGLoginInfo : NSObject {
	NSString *login;
	NSString *passwordHash;
}

@property (nonatomic, retain) NSString *login;
@property (nonatomic, retain) NSString *passwordHash;

@end
