#import "TaskbarButton.h"

#import "Common.h"
#import "FontFactory.h"
#import "Storage.h"
#import "UIColor+CustomColors.h"

@interface TaskbarButton ()

@property (nonatomic, strong) UILabel *counterLabel;
@property (nonatomic, strong) NSObject *observer;

@end

@implementation TaskbarButton

#define kCounterHeight 14

#define kResourceSuffixHighlighted @"_hl"
#define kResourceSuffixSelected @"_sel"

- (void) loadImagesWithName:(NSString *) imageName {
	NSString *imageExt = @".png";
	
	UIImage *image = [UIImage imageNamed: [imageName stringByAppendingString:imageExt]];
	[self setImage: image
					forState: UIControlStateNormal];
	[self setImage: [UIImage imageNamed: [imageName stringByAppendingFormat: @"%@%@",
													  kResourceSuffixSelected, imageExt]]
					forState: UIControlStateSelected];
	[self setImage: [UIImage imageNamed: [imageName stringByAppendingFormat: @"%@%@",
													  kResourceSuffixSelected, imageExt]]
					forState: UIControlStateHighlighted];
}

- (NSString *) localizedTitleForType: (TaskbarButtonType) buttonType {
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
	
	NSString *key = [NSString stringWithFormat: @"title_%d", buttonType];
    NSString *locString = [thisBundle localizedStringForKey: key
													  value: nil table: @"TaskbarButtonLocalizable"];
	if ([locString isEqualToString: key] == YES) {
		locString = nil;
	}
	return locString;
}


#pragma mark Getters and setters

@synthesize type;

#pragma mark Standard overrides


#pragma mark Methods implementation

- (id) initWithType: (TaskbarButtonType) buttonType {
	if (self = [super init]) {
		type = buttonType;
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.imageView.contentMode = UIViewContentModeCenter;
		
		short counterWidth = 18;
		short counterHeight = kCounterHeight;
		_counterLabel = [[UILabel alloc] initWithFrame: CGRectMake(CGRectGetWidth(self.frame) - counterWidth,
																   0, counterWidth, counterHeight)];
		_counterLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		_counterLabel.font = [FontFactory fontWithType: FontTypeMainScreenCounters];
		_counterLabel.backgroundColor = [UIColor colorWithAppColorType: AppColorTypeSecondaryTint];
		_counterLabel.clipsToBounds = YES;
		_counterLabel.layer.cornerRadius = CGRectGetHeight(_counterLabel.frame) / 2;
		_counterLabel.textColor = [UIColor whiteColor];
		_counterLabel.textAlignment = NSTextAlignmentCenter;
		_counterLabel.hidden = YES;
		[self addSubview: _counterLabel];
		
		if (type == TaskbarButtonTypeTask ||
			type == TaskbarButtonTypeFollow ||
			type == TaskbarButtonTypeActions) {
			TaskbarButton __weak *wself = self;
			
			self.observer = [[NSNotificationCenter defaultCenter] addObserverForName: kLGStorageMainScreenInfoChangedNotification
																			  object: nil
																			   queue: [NSOperationQueue mainQueue]
																		  usingBlock:^(NSNotification *note) {
															  LGMainScreenInfo *info = note.object;
															  
															  switch (wself.type) {
																  case TaskbarButtonTypeTask:
																	  [wself setCounterValue: info.tasksCount];
																	  break;
																  case TaskbarButtonTypeFollow:
																	  [wself setCounterValue: info.subscribesCount];
																	  break;
																  case TaskbarButtonTypeActions:
																	  [wself setCounterValue: info.actionCount];
																	  break;
																  default:
																	  break;
															  }
														  }];
		}
		
		[self loadImagesWithName: [NSString stringWithFormat: @"tb_btn_%d", buttonType]];
		
		NSString *title = [self localizedTitleForType: buttonType];
		if (title != nil) {
			self.titleLabel.font = [FontFactory fontWithType: FontTypeTaskbarButtons];
			[self setTitleColor: [FontFactory fontColorForType: FontTypeTaskbarButtons] forState: UIControlStateNormal];
			[self setTitleColor: [UIColor colorWithAppColorType: AppColorTypeSecondaryTint]
					   forState: UIControlStateHighlighted];
			[self setTitle: title forState: UIControlStateNormal];
			
			self.titleEdgeInsets = UIEdgeInsetsMake(34, - self.imageView.image.size.width, 0, 0);
			
			float titleWidth;
			if ([self.titleLabel.text respondsToSelector: @selector(sizeWithAttributes:)] == YES) {
				titleWidth = ceil([self.titleLabel.text sizeWithAttributes:
								   @{NSFontAttributeName: self.titleLabel.font}].width);
			} else {
				titleWidth = [self.titleLabel.text sizeWithFont: self.titleLabel.font].width;
			}
			self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - titleWidth);
		}
	}
	return self;
}

- (void) setCounterValue: (int) value {
	_counterLabel.text = [NSString stringWithFormat: @"%d", value];
	_counterLabel.hidden = value <= 0;
	
	float width = MAX([Common labelWidthWithFont: _counterLabel.font text: _counterLabel.text] + 7, kCounterHeight);
	
	_counterLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) - width, 0, width, kCounterHeight);
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver: self.observer];
}

@end
