//
//  LGLoginInfo.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "JSONSerializableProtocol.h"

@interface LGLoginInfo : NSObject <JSONSerializableProtocol> {
	NSString *login;
	NSString *passwordHash;
}

@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *passwordHash;

@end
