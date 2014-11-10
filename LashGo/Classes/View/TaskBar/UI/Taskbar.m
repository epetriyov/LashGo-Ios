#import "Taskbar.h"

#define kTaskbarSpaceWidth 0

@implementation Taskbar

#pragma mark Internal methods

- (void) removeButtons {
	for (TaskbarButton *button in buttons) {
		[button removeFromSuperview];
	}
	[buttons removeAllObjects];
}

- (void) insertButton: (TaskbarButton *) button {
	[self addSubview: button];
}

- (void) loadContents {
	float buttonWidth = self.frame.size.width / [buttonsTypes count];
	
	[self removeButtons];
	for (ushort i = 0; i < [buttonsTypes count]; ++i) {
		TaskbarButton *button = [[TaskbarButton alloc] initWithType: [buttonsTypes[i] intValue]];
		button.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, self.frame.size.height);
		[button addTarget: self action: @selector(taskbarButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
		
		[buttons addObject: button];
		[self performSelectorOnMainThread: @selector(insertButton:) withObject: button waitUntilDone: YES];
	}
}

- (void) backgroundLoading {
	@autoreleasepool {
		[self loadContents];
	}
}

- (void) load {
//!!!: for now sync loading
//	[self performSelectorInBackground: @selector(backgroundLoading) withObject: nil];
	[self backgroundLoading];
}

#pragma mark Getters and setters

@synthesize delegate;

#pragma mark Standard overrides

- (id) initWithFrame: (CGRect) theFrame {
	if (self = [super initWithFrame: theFrame]) {
		delegate = nil;
		buttons = [[NSMutableArray alloc] init];
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//		[self load];
	}
	return self;
}

#pragma mark - Methods implementation

- (void) setBackgroundView: (UIView *) bgView {
	bgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	
	[backgroundView removeFromSuperview];
	backgroundView = bgView;
	[self insertSubview: backgroundView atIndex: 0];
}

- (void) setTypes: (NSArray *) btnTypes {
	buttonsTypes = btnTypes;
	[self loadContents];
}

- (void) setButtonsTypes: (NSArray *) btnTypes {
	if (btnTypes != nil && btnTypes.count != [buttonsTypes count]) {
		[self setTypes: btnTypes];
	} else if (btnTypes != nil && btnTypes.count == [buttonsTypes count]) {
		for (ushort i = 0; i < btnTypes.count; ++i) {
			NSInteger oldN = [btnTypes[i] integerValue];
			NSInteger newN = [buttonsTypes[i] integerValue];
			if (oldN != newN) {
				[self setTypes: btnTypes];
				return;
			}
		}
	}
}

#pragma mark -

- (void) selectButtonWithType: (TaskbarButtonType)buttonType {
	for (TaskbarButton *theButton in buttons) {
		if (theButton.type == buttonType) {
			theButton.selected = YES;
            theButton.userInteractionEnabled = NO;
		} else {
			theButton.selected = NO;
			theButton.userInteractionEnabled = YES;
		}
	}
}

- (void) deselectButtons {
	for (TaskbarButton *theButton in buttons) {
		theButton.selected = NO;
        theButton.userInteractionEnabled = YES;
	}
}

- (UIButton *) buttonWithType:(TaskbarButtonType)buttonType {
	for (TaskbarButton *theButton in buttons) {
		if (theButton.type == buttonType) {
			return theButton;
		}
	}
	return nil;
}

- (void) taskbarButtonPressed: (UIButton *) sender {
	[self.delegate taskbar:self didSelectedButton: (TaskbarButton*)sender];
}

@end
