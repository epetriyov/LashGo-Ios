//
//  SegmentedTextControl.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 22.01.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "SegmentedTextControl.h"

#import "ViewFactory.h"
#import "FontFactory.h"
#import "Common.h"
#import "UIView+CGExtension.h"

@interface SegmentedTextControl () {
	ushort _selectedIndex;
}

@end

@implementation SegmentedTextControl

@synthesize delegate;
@dynamic selectedIndex;

- (ushort) selectedIndex {
	return _selectedIndex;
}

- (void) setSelectedIndex: (ushort) value {
	UIButton *oldSelectedButton = buttons[_selectedIndex];
	oldSelectedButton.selected = NO;
	
	UIButton *newSelectedButton = buttons[value];
	newSelectedButton.selected = YES;
	
	_selectedIndex = value;
}

#pragma mark -

- (id) initWithItemsCount: (ushort) count {
	if (self = [super init]) {
		buttons = [[NSMutableArray alloc] initWithCapacity: count];
	}
	return self;
}

- (id) initWithButtonsTexts: (NSArray *) buttonsTexts
			  buttonsBgName: (NSString *) buttonsBg
					 bgName: (NSString *) bg {
	ushort count = (ushort)[buttonsTexts count];
	if (self = [self initWithItemsCount: count]) {
		_selectedIndex = 0;
		
		UIImage *background = [[ViewFactory sharedFactory] getImageWithName: bg];
		UIImageView *bgView = [[UIImageView alloc] initWithImage: background];
		self.frame = CGRectMake(0, 0, background.size.width, background.size.height);
		[self addSubview: bgView];
		
		float buttonsFullWidth = 0;
		float buttonsHeight = 0;
		
		for (ushort i = 0; i < count; ++i) {
			UIButton *button = [[ViewFactory sharedFactory] buttonWithBGImageName: [NSString stringWithFormat: @"%@_%d", buttonsBg, i]
																	   target: self action: @selector(buttonTouchAction:)];
			[button.titleLabel setFont: [FontFactory fontWithType: FontTypeSegmentedTextControl]];
			[button setTitleColor: [FontFactory fontColorForType: FontTypeSegmentedTextControl]
						 forState: UIControlStateNormal];
			[button setTitleColor: [FontFactory fontColorForType: FontTypeSegmentedTextControlSelected]
						 forState: UIControlStateSelected];
			[button setTitle: buttonsTexts[i] forState: UIControlStateNormal];
			
			button.selected = (i == _selectedIndex);
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

- (void) buttonTouchAction: (UIButton *) sender {
	ushort newIndex = (ushort)[buttons indexOfObject: sender];
	if (newIndex != _selectedIndex) {
		self.selectedIndex = newIndex;
		if ([delegate respondsToSelector: @selector(segmentedControl:selectedIndexChangedTo:)] == YES) {
			[delegate segmentedControl: self selectedIndexChangedTo: newIndex];
		}
	}
}

@end
