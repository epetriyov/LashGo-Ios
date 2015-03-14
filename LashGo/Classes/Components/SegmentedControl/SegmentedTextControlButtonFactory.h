//
//  SegmentedTextControlButtonFactory.h
//  SmartKeeper
//
//  Created by Vitaliy Pykhtin on 12.03.15.
//  Copyright (c) 2015 Soft-logic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(ushort, SegmentedTextControlSegment) {
	SegmentedTextControlSegmentMiddle = 0,
	SegmentedTextControlSegmentLeft,
	SegmentedTextControlSegmentRight
};

@interface SegmentedTextControlButtonFactory : NSObject

+ (UIButton *) borderedButtonWithSegment: (SegmentedTextControlSegment) segment size: (CGSize) size
								   title: (NSString *) title
								  target: (id) target action: (SEL) selector;

@end
