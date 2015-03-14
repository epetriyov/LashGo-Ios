//
//  SegmentedTextControl.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 22.01.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "SegmentedTextControl.h"

#import "SegmentedTextControlButtonFactory.h"
#import "UIColor+CustomColors.h"
#import "ViewFactory.h"
#import "FontFactory.h"
#import "Common.h"
#import "UIView+CGExtension.h"

@interface SegmentedTextControl () {
	ushort selectedIndex;
	
	NSMutableArray *buttons;
}

@end

@implementation SegmentedTextControl

@dynamic selectedIndex;

- (ushort) selectedIndex {
	return selectedIndex;
}

- (void) setSelectedIndex: (ushort) value {
	ushort newSelectedIndex = MIN(value, [buttons count] - 1);
	if (selectedIndex != newSelectedIndex) {
		UIButton *oldSelectedButton = buttons[selectedIndex];
		oldSelectedButton.selected = NO;
		oldSelectedButton.userInteractionEnabled = YES;
		
		UIButton *newSelectedButton = buttons[newSelectedIndex];
		newSelectedButton.selected = YES;
		newSelectedButton.userInteractionEnabled = NO;
		
		selectedIndex = newSelectedIndex;
	}
}

#pragma mark -

- (instancetype) initWithFrame: (CGRect) frame
					itemsCount: (ushort) count {
	if (self = [super initWithFrame: frame]) {
		buttons = [[NSMutableArray alloc] initWithCapacity: count];
	}
	return self;
}

- (instancetype) initWithFrame: (CGRect) frame
				  buttonsTexts: (NSArray *) buttonsTexts
				 buttonsBgName: (NSString *) buttonsBg
						bgName: (NSString *) bg {
	NSAssert([buttonsTexts count] < 40, @"Too much items set for SegmentedTextControl");
	ushort count = (ushort)[buttonsTexts count];
	if (self = [self initWithFrame: frame itemsCount: count]) {
		selectedIndex = 0;
		
		UIImage *background = [[ViewFactory sharedFactory] getImageWithName: bg];
		if (background != nil) {
			UIImageView *bgView = [[UIImageView alloc] initWithFrame: self.bounds];
			bgView.contentMode = UIViewContentModeScaleToFill;
			bgView.image = background;
			[self addSubview: bgView];
		}
		
		float buttonsFullWidth = 0;
		float buttonsHeight = 0;
		
		for (ushort i = 0; i < count; ++i) {
			UIButton *button = [[ViewFactory sharedFactory] buttonWithBGImageName: [NSString stringWithFormat: @"%@_%d", buttonsBg, i]
																	   target: self action: @selector(buttonTouchAction:)];
			button.titleLabel.adjustsFontSizeToFitWidth = YES;
			button.titleLabel.numberOfLines = 1;
			[button.titleLabel setFont: [FontFactory fontWithType: FontTypeSegmentedTextControl]];
			[button setTitleColor: [FontFactory fontColorForType: FontTypeSegmentedTextControl]
						 forState: UIControlStateNormal];
			[button setTitleColor: [FontFactory fontColorForType: FontTypeSegmentedTextControlSelected]
						 forState: UIControlStateSelected];
			[button setTitle: buttonsTexts[i] forState: UIControlStateNormal];
			
			button.selected = (i == selectedIndex);
			button.userInteractionEnabled = (i != selectedIndex);
			buttonsFullWidth += button.frame.size.width;
			[buttons addObject: button];
			[self addSubview: button];
			
			buttonsHeight = button.frame.size.height;
		}
		
		//position buttons
		float offsetX = MAX((self.frame.size.width - buttonsFullWidth) / 2, 0);
		float offsetY = MAX((self.frame.size.height - buttonsHeight) / 2, 0);
		
		for (UIButton *button in buttons) {
			button.frameX = offsetX;
			button.frameY = offsetY;
			offsetX += button.frame.size.width;
		}
	}
	return self;
}

- (instancetype) initWithFrame: (CGRect) frame
				  buttonsTexts: (NSArray *) buttonsTexts
						bgName: (NSString *) bg
	  contentVerticalAlignment: (UIControlContentVerticalAlignment) verticalAlignment {
	NSAssert([buttonsTexts count] < 40, @"Too much items set for SegmentedTextControl");
	ushort count = (ushort)[buttonsTexts count];
	if (self = [self initWithFrame: frame itemsCount: count]) {
		selectedIndex = 0;
		self.backgroundColor = [UIColor colorWithAppColorType: AppColorTypeTint];
		self.contentVerticalAlignment = verticalAlignment;
		
		//Configure background
		UIImage *background = nil;
		
		if ([Common isEmptyString: bg] == NO) {
			background = [[ViewFactory sharedFactory] getImageWithName: bg];
		}
		if (background != nil) {
			UIImageView *bgView = [[UIImageView alloc] initWithFrame: self.bounds];
			bgView.contentMode = UIViewContentModeScaleToFill;
			bgView.image = background;
			[self addSubview: bgView];
		}
		
		//Configure border
		UIView *buttonsBorderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 308, 30)];
		switch (self.contentVerticalAlignment) {
			case UIControlContentVerticalAlignmentCenter:
				buttonsBorderView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
				break;
			default:
				buttonsBorderView.centerX = CGRectGetMidX(self.bounds);
				break;
		}
		
		buttonsBorderView.backgroundColor = [UIColor whiteColor];
		buttonsBorderView.layer.cornerRadius = 5;
		[self addSubview: buttonsBorderView];
		
		CGFloat buttonsGaps = 1;
		float buttonsWidth = ceil((CGRectGetWidth(buttonsBorderView.bounds) - buttonsGaps * (count + 1)) / count);
		float buttonsHeight = CGRectGetHeight(buttonsBorderView.bounds) - buttonsGaps * 2;
		float buttonsCenterY = CGRectGetMidY(buttonsBorderView.bounds);
		float buttonsCenterX = CGRectGetWidth(buttonsBorderView.bounds) / (count * 2);
		
		for (ushort i = 0; i < count; ++i) {
			SegmentedTextControlSegment segment = SegmentedTextControlSegmentMiddle;
			if (i == 0) {
				segment = SegmentedTextControlSegmentLeft;
			} else if (i == count - 1) {
				segment = SegmentedTextControlSegmentRight;
			}
			UIButton *button = [SegmentedTextControlButtonFactory borderedButtonWithSegment: segment
																					   size: CGSizeMake(buttonsWidth, buttonsHeight)
																					  title: buttonsTexts[i]
																					 target: self
																					 action: @selector(buttonTouchAction:)];
			button.center = CGPointMake((i * 2 + 1) * buttonsCenterX, buttonsCenterY);
			
			button.selected = (i == selectedIndex);
			button.userInteractionEnabled = (i != selectedIndex);
			[buttons addObject: button];
			[buttonsBorderView addSubview: button];
		}
	}
	return self;
}

- (void) buttonTouchAction: (UIButton *) sender {
	ushort newIndex = (ushort)[buttons indexOfObject: sender];
	if (newIndex != selectedIndex) {
		self.selectedIndex = newIndex;
		
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

@end
