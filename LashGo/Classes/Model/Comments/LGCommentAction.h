//
//  LGCommentSendAction.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 14.03.15.
//  Copyright (c) 2015 Vitaliy Pykhtin. All rights reserved.
//

#import "JSONSerializableProtocol.h"

#import "LGComment.h"
#import "LGPhoto.h"

@interface LGCommentAction : NSObject <JSONSerializableProtocol>

@property (nonatomic, strong) id context;
@property (nonatomic, strong) LGComment *comment;

@end
