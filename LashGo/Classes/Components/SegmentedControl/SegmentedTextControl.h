//
//  SegmentedTextControl.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 22.01.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentedTextControlDelegate;

@interface SegmentedTextControl : UIView {
	NSMutableArray *buttons;
}

@property (nonatomic, weak) id<SegmentedTextControlDelegate> delegate;
@property (nonatomic, assign) ushort selectedIndex;

- (id) initWithItemsCount: (ushort) count;
- (id) initWithButtonsTexts: (NSArray *) buttonsTexts
			  buttonsBgName: (NSString *) buttonsBg
					 bgName: (NSString *) bg;

@end

@protocol SegmentedTextControlDelegate <NSObject>

@required
- (void) segmentedControl: (SegmentedTextControl *) segmentedTextControl selectedIndexChangedTo: (ushort) selectedIndex;

@end
