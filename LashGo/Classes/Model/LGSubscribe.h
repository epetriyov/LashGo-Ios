//
//  LGSubscribe.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 30.11.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "JSONSerializableProtocol.h"
#import "LGSubscription.h"

@interface LGSubscribe : NSObject <JSONSerializableProtocol>

@property (nonatomic, strong) LGSubscription *subscription;

@end
