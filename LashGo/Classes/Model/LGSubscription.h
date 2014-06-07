//
//  LGSubscription.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGSubscription : NSObject {
	int32_t uid;
	int32_t userUID;
	NSString *userAvatarURL;
	NSString *userLogin;
}

@property (nonatomic, assign) int32_t uid;
@property (nonatomic, assign) int32_t userUID;
@property (nonatomic, strong) NSString *userAvatarURL;
@property (nonatomic, strong) NSString *userLogin;

@end
