//
//  SegmentedTextControlButtonFactory.m
//  SmartKeeper
//
//  Created by Vitaliy Pykhtin on 12.03.15.
//  Copyright (c) 2015 Soft-logic LLC. All rights reserved.
//

#import "SegmentedTextControlButtonFactory.h"

#import "FontFactory.h"
#import "UIColor+CustomColors.h"
#import "ViewFactory.h"

@implementation SegmentedTextControlButtonFactory

+ (UIView *) borderedButtonWithSegment: (SegmentedTextControlSegment) segment size: (CGSize) size
								 title: (NSString *) title
								target: (id) target action: (SEL) selector {
	UIColor *borderColor = [UIColor whiteColor];
	UIColor *mainColor = [UIColor colorWithAppColorType: AppColorTypeTint];
	
	UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, size.width, size.height)];
	button.backgroundColor = mainColor;
//	button.layer.cornerRadius = 4;
	button.titleLabel.font = [FontFactory fontWithType: FontTypeSegmentedTextControl];
	button.titleLabel.adjustsFontSizeToFitWidth = YES;
	button.titleLabel.numberOfLines = 1;
	[button setTitle: title forState: UIControlStateNormal];
	[button setTitleColor: borderColor forState: UIControlStateNormal];
	[button setTitleColor: mainColor forState: UIControlStateSelected];
	[button addTarget: target action: selector forControlEvents: UIControlEventTouchUpInside];
	
	CGRect rect = CGRectMake(0, 0, 1, 1);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, borderColor.CGColor);
	CGContextFillRect(context, rect);
	UIImage *highlightedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	[button setBackgroundImage: highlightedImage forState: UIControlStateSelected];
	
	if (segment != SegmentedTextControlSegmentMiddle) {
		UIRectCorner roundedCorners = UIRectCornerAllCorners;
		
		if (segment == SegmentedTextControlSegmentLeft) {
			roundedCorners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
		} else if (segment == SegmentedTextControlSegmentRight) {
			roundedCorners = UIRectCornerTopRight | UIRectCornerBottomRight;
		}
		
		UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: button.bounds
													   byRoundingCorners: roundedCorners
															 cornerRadii: CGSizeMake(4.5, 4.5)];
		
		CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
		maskLayer.frame = button.bounds;
		maskLayer.path = maskPath.CGPath;
		
		button.layer.mask = maskLayer;
	}
	
	return button;
}

@end
