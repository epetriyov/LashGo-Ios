//
//  SegmentedTextControl.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 22.01.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <UIKit/UIKit.h>

///Implements UIControlValueChanged on user select new index
@interface SegmentedTextControl : UIControl

@property (nonatomic, assign) ushort selectedIndex;

- (instancetype) initWithFrame: (CGRect) frame
				  buttonsTexts: (NSArray *) buttonsTexts
				 buttonsBgName: (NSString *) buttonsBg
						bgName: (NSString *) bg;
- (instancetype) initWithFrame: (CGRect) frame
				  buttonsTexts: (NSArray *) buttonsTexts
						bgName: (NSString *) bg
	  contentVerticalAlignment: (UIControlContentVerticalAlignment) verticalAlignment;

@end
