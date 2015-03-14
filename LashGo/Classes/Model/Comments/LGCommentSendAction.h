//
//  LGCommentSendAction.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.03.15.
//  Copyright (c) 2015 Vitaliy Pykhtin. All rights reserved.
//

#import "JSONSerializableProtocol.h"

#import "LGPhoto.h"

@interface LGCommentSendAction : NSObject <JSONSerializableProtocol>

@property (nonatomic, assign) int64_t checkUID;
@property (nonatomic, strong) LGPhoto *photo;
@property (nonatomic, strong) NSString *comment;

@end
