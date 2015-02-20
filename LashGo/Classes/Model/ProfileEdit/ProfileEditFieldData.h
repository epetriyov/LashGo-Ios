//
//  ProfileEditField.h
//  LashGo
//
//  Created by Admin on 17.02.15.
//  Copyright (c) 2015 Vitaliy Pykhtin. All rights reserved.
//

@interface ProfileEditFieldData : NSObject

@property (nonatomic, assign) ushort uid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) UIImage *image;

@end
