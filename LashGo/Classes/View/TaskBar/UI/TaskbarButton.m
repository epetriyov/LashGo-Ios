#import "TaskbarButton.h"

#import "FontFactory.h"
#import "Storage.h"
#import "UIColor+CustomColors.h"

@interface TaskbarButton ()

@property (nonatomic, strong) UILabel *counterLabel;
@property (nonatomic, strong) NSObject *observer;

@end

@implementation TaskbarButton

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
		short counterHeight = 10;
		_counterLabel = [[UILabel alloc] initWithFrame: CGRectMake(CGRectGetWidth(self.frame) - counterWidth,
																   0, counterWidth, counterHeight)];
		_counterLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		_counterLabel.font = [FontFactory fontWithType: FontTypeMainScreenCounters];
		_counterLabel.backgroundColor = [UIColor whiteColor];
		_counterLabel.clipsToBounds = YES;
		_counterLabel.layer.cornerRadius = CGRectGetHeight(_counterLabel.frame) / 2;
		_counterLabel.textColor = [FontFactory fontColorForType: FontTypeMainScreenCounters];
		_counterLabel.textAlignment = NSTextAlignmentCenter;
		_counterLabel.hidden = YES;
		[self addSubview: _counterLabel];
		
		if (type == TaskbarButtonTypeTask ||
			type == TaskbarButtonTypeFollow ||
			type == TaskbarButtonTypeNews) {
			TaskbarButton __weak *wself = self;
			
			self.observer = [[NSNotificationCenter defaultCenter] addObserverForName: kLGStorageMainScreenInfoChangedNotification
																			  object: nil
																			   queue: [NSOperationQueue mainQueue]
																		  usingBlock:^(NSNotification *note) {
							  LGMainScreenInfo *info = note.object;
							  
							  BOOL isHidden = YES;
							  switch (wself.type) {
								  case TaskbarButtonTypeTask:
									  isHidden = info.tasksCount <= 0;
									  wself.counterLabel.text = [NSString stringWithFormat: @"%d", info.tasksCount];
									  break;
								  case TaskbarButtonTypeFollow:
									  isHidden = info.subscribesCount <= 0;
									  wself.counterLabel.text = [NSString stringWithFormat: @"%d", info.subscribesCount];
									  break;
								  case TaskbarButtonTypeNews:
									  isHidden = info.newsCount <= 0;
									  wself.counterLabel.text = [NSString stringWithFormat: @"%d", info.newsCount];
									  break;
								  default:
									  break;
							  }
							  wself.counterLabel.hidden = isHidden;
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

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver: self.observer];
}

@end
