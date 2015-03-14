//
//  UIColor+CustomColors.m
//  SmartKeeper
//
//  Created by Vitaliy Pykhtin on 29.10.14.
//  Copyright (c) 2014 Soft-logic LLC. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+ (UIColor *) colorWithAppColorType: (AppColorType) colorType {
	switch (colorType) {
		case AppColorTypeTint:			return [UIColor colorWithRed: 0 green: 172.0/255.0 blue: 193.0/255.0
														alpha: 1.0];
		case AppColorTypeSecondaryTint:	return [UIColor colorWithRed: 1.0 green: 94.0/255.0 blue: 124.0/255.0
															   alpha: 1.0];
		default:
			break;
	}
	return nil;
}

@end
