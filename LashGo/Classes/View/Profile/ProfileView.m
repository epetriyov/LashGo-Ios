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
#import "UIView+CGExtension.h"
#import "UIImageView+LGImagesExtension.h"

@interface ProfileView () {
	UIImageView *_avatarImageView;
	
	UILabel *_subscribesLabel;
	UILabel *_subscribesCountLabel;
	UILabel *_subscribersLabel;
	UILabel *_subscribersCountLabel;
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
		_avatarImageView.backgroundColor = [UIColor colorWithRed: 0 green: 172.0/255.0 blue: 193.0/255.0 alpha: 1.0];
		_avatarImageView.contentMode = UIViewContentModeBottom;
		_avatarImageView.userInteractionEnabled = YES;
		_avatarImageView.image = [ViewFactory sharedFactory].userProfileAvatarPlaceholder;
		[self addSubview: _avatarImageView];
		
		float bottomOffsetY = 100;
		float followCaps = 15;
		float followCountCaps = 5;
		float followCountHeight = 19;
		
		_subscribesLabel = [[UILabel alloc] init];
		_subscribesLabel.backgroundColor = [UIColor clearColor];
		_subscribesLabel.font = [FontFactory fontWithType: FontTypeProfileLabels];
		_subscribesLabel.textColor = [FontFactory fontColorForType: FontTypeProfileLabels];
		_subscribesLabel.text = [@"ProfileViewControllerSubscribes" stringByAppendingString:
								 [Common pluralSuffix: 0]].commonLocalizedString;
		[_subscribesLabel sizeToFit];
		_subscribesLabel.frameY = bottomOffsetY - _subscribesLabel.frame.size.height;
		_subscribesLabel.frameX = frame.size.width - _subscribesLabel.frame.size.width - followCaps;
		[self addSubview: _subscribesLabel];
		
		_subscribesCountLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, bottomOffsetY - followCountHeight,
																		   _subscribesLabel.frame.origin.x - followCountCaps,
																		   followCountHeight)];
		_subscribesCountLabel.backgroundColor = [UIColor clearColor];
		_subscribesCountLabel.font = [FontFactory fontWithType: FontTypeProfileLabelsFollowCount];
		_subscribesCountLabel.textAlignment = NSTextAlignmentRight;
		_subscribesCountLabel.textColor = [FontFactory fontColorForType: FontTypeProfileLabelsFollowCount];
		[self addSubview: _subscribesCountLabel];
		
		_subscriptionsButton = [[UIButton alloc] initWithFrame: CGRectMake(_subscribesLabel.frame.origin.x - 30,
																		   _subscribesCountLabel.frame.origin.y,
																		   self.bounds.size.width - _subscribesLabel.frame.origin.x + 30,
																		   _subscribesCountLabel.frame.size.height)];
		[self addSubview: _subscriptionsButton];
		
		bottomOffsetY += 42;
		
		_subscribersLabel = [[UILabel alloc] init];
		_subscribersLabel.backgroundColor = [UIColor clearColor];
		_subscribersLabel.font = [FontFactory fontWithType: FontTypeProfileLabels];
		_subscribersLabel.textColor = [FontFactory fontColorForType: FontTypeProfileLabels];
		_subscribersLabel.text = [@"ProfileViewControllerSubscribers" stringByAppendingString:
								  [Common pluralSuffix: 0]].commonLocalizedString;
		[_subscribersLabel sizeToFit];
		_subscribersLabel.frameY = bottomOffsetY - _subscribersLabel.frame.size.height;
		_subscribersLabel.frameX = frame.size.width - _subscribersLabel.frame.size.width - followCaps;
		[self addSubview: _subscribersLabel];
		
		_subscribersCountLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, bottomOffsetY - followCountHeight,
																		   _subscribersLabel.frame.origin.x - followCountCaps,
																		   followCountHeight)];
		_subscribersCountLabel.backgroundColor = [UIColor clearColor];
		_subscribersCountLabel.font = [FontFactory fontWithType: FontTypeProfileLabelsFollowCount];
		_subscribersCountLabel.textAlignment = NSTextAlignmentRight;
		_subscribersCountLabel.textColor = [FontFactory fontColorForType: FontTypeProfileLabelsFollowCount];
		[self addSubview: _subscribersCountLabel];
		
		_subscribersButton = [[UIButton alloc] initWithFrame: CGRectMake(_subscribersLabel.frame.origin.x - 30,
																		 _subscribersCountLabel.frame.origin.y,
																		 self.bounds.size.width - _subscribersLabel.frame.origin.x + 30,
																		 _subscribersCountLabel.frame.size.height)];
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

- (void) setUserData: (LGUser *) user {
	[_avatarImageView loadWebImageShadedWithSizeThatFitsName: user.avatar
										   placeholder: [ViewFactory sharedFactory].userProfileAvatarPlaceholder];
	NSString *format = @"%0d ";
	_subscribesCountLabel.text =	[[NSString alloc] initWithFormat: format, user.userSubscribes];
	_subscribesLabel.text = [@"ProfileViewControllerSubscribes" stringByAppendingString:
							 [Common pluralSuffix: user.userSubscribes]].commonLocalizedString;
	_subscribersCountLabel.text =	[[NSString alloc] initWithFormat: format, user.userSubscribers];
	_subscribersLabel.text = [@"ProfileViewControllerSubscribers" stringByAppendingString:
							  [Common pluralSuffix: user.userSubscribers]].commonLocalizedString;
	_countersLabel.text =			[self pluralizedStringWithChecks: user.checksCount
													comments:user.commentsCount
													   likes:user.likesCount];
	
	_fioLabel.text = user.fio;
}

@end
