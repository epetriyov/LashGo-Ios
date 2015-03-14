//
//  ProfileView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ProfileView.h"

#import "Common.h"
#import "FontFactory.h"
#import "ViewFactory.h"
#import "UIColor+CustomColors.h"
#import "UIView+CGExtension.h"
#import "UIImageView+LGImagesExtension.h"

@interface ProfileView () {
	UIImageView *_avatarImageView;
	
	UILabel *_subscribesLabel;
	UILabel *_subscribersLabel;
	UILabel *_countersLabel;
	
	UILabel *_fioLabel;
}

@end

@implementation ProfileView

- (id)initWithFrame:(CGRect)frame
{
	CGRect requiredFrame = frame;
	requiredFrame.size.height = 280;
    self = [super initWithFrame: requiredFrame];
    if (self) {
		_avatarImageView = [[UIImageView alloc] initWithFrame: self.bounds];
		_avatarImageView.backgroundColor = [UIColor colorWithAppColorType: AppColorTypeTint];
		_avatarImageView.contentMode = UIViewContentModeBottom;
		_avatarImageView.userInteractionEnabled = YES;
		_avatarImageView.image = [ViewFactory sharedFactory].userProfileAvatarPlaceholder;
		[self addSubview: _avatarImageView];
		
		float bottomOffsetY = 100;
		float followCaps = 15;
		float followCountHeight = 19;
		
		_subscribesLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, bottomOffsetY - followCountHeight,
																		   CGRectGetWidth(requiredFrame) - followCaps,
																		   followCountHeight)];
		_subscribesLabel.backgroundColor = [UIColor clearColor];
		_subscribesLabel.font = [FontFactory fontWithType: FontTypeProfileLabels];
		_subscribesLabel.textColor = [FontFactory fontColorForType: FontTypeProfileLabels];
		_subscribesLabel.textAlignment = NSTextAlignmentRight;
		_subscribesLabel.attributedText = [self subscribeLabelWithCount: 0
															  text: [@"ProfileViewControllerSubscribes" stringByAppendingString:
																	 [Common pluralSuffix: 0]].commonLocalizedString];
		[self addSubview: _subscribesLabel];
		
		_subscriptionsButton = [[UIButton alloc] initWithFrame: _subscribesLabel.frame];
		[self addSubview: _subscriptionsButton];
		
		bottomOffsetY += 42;
		
		_subscribersLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, bottomOffsetY - followCountHeight,
																		   CGRectGetWidth(requiredFrame) - followCaps,
																		   followCountHeight)];
		_subscribersLabel.backgroundColor = [UIColor clearColor];
		_subscribersLabel.font = [FontFactory fontWithType: FontTypeProfileLabels];
		_subscribersLabel.textColor = [FontFactory fontColorForType: FontTypeProfileLabels];
		_subscribersLabel.textAlignment = NSTextAlignmentRight;
		_subscribersLabel.attributedText = [self subscribeLabelWithCount: 0
																		 text: [@"ProfileViewControllerSubscribers" stringByAppendingString:
																				[Common pluralSuffix: 0]].commonLocalizedString];
		[self addSubview: _subscribersLabel];
		
		_subscribersButton = [[UIButton alloc] initWithFrame: _subscribersLabel.frame];
		[self addSubview: _subscribersButton];
		
		//Bottom to top
		float offsetY = self.frame.size.height - 62;
//		62
		UIView *bgView = [[UIView alloc] initWithFrame: CGRectMake(0, offsetY,
																   self.frame.size.width, 62)];
		bgView.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0.3];
		[self addSubview: bgView];
		
		_fioLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY, self.frame.size.width, 22)];
		_fioLabel.backgroundColor = [UIColor clearColor];
		_fioLabel.font = [FontFactory fontWithType: FontTypeProfileFIO];
		_fioLabel.textAlignment = NSTextAlignmentCenter;
		_fioLabel.textColor = [FontFactory fontColorForType: FontTypeProfileFIO];
		[self addSubview: _fioLabel];
		
		offsetY += _fioLabel.frame.size.height;
		
		UIView *line = [[UIView alloc] initWithFrame: CGRectMake(0, offsetY, self.frame.size.width, 1)];
		line.backgroundColor = [UIColor colorWithWhite: 1 alpha: 77.0/255.0];
		[self addSubview: line];
		
		_countersLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY, self.frame.size.width,
																	self.frame.size.height - offsetY)];
		_countersLabel.backgroundColor = [UIColor clearColor];
		_countersLabel.font = [FontFactory fontWithType: FontTypeProfileLabelsCount];
		_countersLabel.textColor = [FontFactory fontColorForType: FontTypeProfileLabelsCount];
		_countersLabel.text = [self pluralizedStringWithChecks: 0 comments: 0 likes: 0];
		_countersLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview: _countersLabel];
    }
    return self;
}


- (NSString *) pluralizedStringWithChecks: (int32_t) checksCount
								 comments: (int32_t) commentsCount
									likes: (int32_t) likesCount {
	NSString *checksCountLabel = [@"ProfileViewControllerCountersCheck" stringByAppendingString:
								  [Common pluralSuffix: checksCount]].commonLocalizedString;
	NSString *commentsCountLabel = [@"ProfileViewControllerCountersComment" stringByAppendingString:
									[Common pluralSuffix: commentsCount]].commonLocalizedString;
	NSString *likesCountLabel = [@"ProfileViewControllerCountersLike" stringByAppendingString:
								 [Common pluralSuffix: likesCount]].commonLocalizedString;
	
	return [NSString stringWithFormat: @"ProfileViewControllerCountersLabelFormat".commonLocalizedString,
			checksCount, checksCountLabel, commentsCount, commentsCountLabel, likesCount, likesCountLabel];
}

- (NSAttributedString *) subscribeLabelWithCount: (int32_t) count text: (NSString *) text {
	NSString *format = @"%0d ";
	NSMutableString *resultString = [[NSMutableString alloc] initWithFormat: format, count];
	NSUInteger countLength = [resultString length];
	
	[resultString appendString: text];
	
	NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]
												initWithString:resultString];
	[attributedStr addAttribute: NSFontAttributeName value: [FontFactory fontWithType: FontTypeProfileLabelsFollowCount]
						 range: NSMakeRange(0, countLength)];
	return attributedStr;
}

- (void) setUserData: (LGUser *) user {
	[_avatarImageView loadWebImageShadedWithSizeThatFitsName: user.avatar
										   placeholder: [ViewFactory sharedFactory].userProfileAvatarPlaceholder];
	
	_subscribesLabel.attributedText =	[self subscribeLabelWithCount: user.userSubscribes
																	text: [@"ProfileViewControllerSubscribes" stringByAppendingString:
																		   [Common pluralSuffix: user.userSubscribes]].commonLocalizedString];
	_subscribersLabel.attributedText = [self subscribeLabelWithCount: user.userSubscribers
																	 text:[@"ProfileViewControllerSubscribers" stringByAppendingString:
																		   [Common pluralSuffix: user.userSubscribers]].commonLocalizedString];
	_countersLabel.text =			[self pluralizedStringWithChecks: user.checksCount
													comments:user.commentsCount
													   likes:user.likesCount];
	
	_fioLabel.text = user.fio;
}

@end
