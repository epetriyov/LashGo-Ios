//
//  LGSocialInfo.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 04.08.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "JSONSerializableProtocol.h"

@interface LGSocialInfo : NSObject <JSONSerializableProtocol>

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *accessTokenSecret;
@property (nonatomic, strong) NSString *socialName;

@end
