//
//  LGRecoverInfo.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "JSONSerializableProtocol.h"

@interface LGRecoverInfo : NSObject <JSONSerializableProtocol>

@property (nonatomic, strong) NSString *email;

@end
