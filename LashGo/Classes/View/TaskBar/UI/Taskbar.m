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
	int space = kTaskbarSpaceWidth;
	float buttonPosition = 0;
	
	[self removeButtons];
	for (NSNumber *buttonType in buttonsTypes) {
		TaskbarButton *button = [[TaskbarButton alloc] initWithType: [buttonType intValue]];
		[button addTarget: self action: @selector(taskbarButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
		
		CGRect frame = button.frame;
		frame.origin.x = buttonPosition;
		frame.origin.y = (self.frame.size.height - frame.size.height) / 2;
		
		button.frame = frame;

		[buttons addObject: button];
		[self performSelectorOnMainThread: @selector(insertButton:) withObject: button waitUntilDone: YES];
		
		buttonPosition += frame.size.width + space;
	}
}

- (void) backgroundLoading {
	@autoreleasepool {
		[self loadContents];
		
		[self performSelectorOnMainThread: @selector(loadingIsFinished) withObject: nil waitUntilDone: NO];
	}
}

- (void) loadingIsFinished {
}

- (void) load {
//!!!: for now sync loading
//	[self performSelectorInBackground: @selector(backgroundLoading) withObject: nil];
	[self backgroundLoading];
}

#pragma mark Getters and setters

@synthesize delegate;

#pragma mark Standard overrides

- (void) dealloc {
	[buttonsTypes release];
	[buttons release];
	
	[super dealloc];
}

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
	if (buttonsTypes != btnTypes) {
		[buttonsTypes release];
		buttonsTypes = [btnTypes retain];
	}
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
	if ([self.delegate respondsToSelector: @selector(taskbar:didSelectedButton:)] == YES) {
		[self.delegate taskbar:self didSelectedButton: (TaskbarButton*)sender];
	}
}

@end
