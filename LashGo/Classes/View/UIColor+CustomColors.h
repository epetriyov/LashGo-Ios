//
//  UIColor+CustomColors.h
//  SmartKeeper
//
//  Created by Vitaliy Pykhtin on 29.10.14.
//  Copyright (c) 2014 Soft-logic LLC. All rights reserved.
//

typedef NS_ENUM(ushort, AppColorType) {
	AppColorTypeTint = 0,
	AppColorTypeSecondaryTint
};

@interface UIColor (CustomColors)

+ (UIColor *) colorWithAppColorType: (AppColorType) colorType;

@end
