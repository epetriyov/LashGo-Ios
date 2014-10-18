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
	UILabel *_checksLabel;
	UILabel *_checksCountLabel;
	UILabel *_commentsLabel;
	UILabel *_commentsCountLabel;
	UILabel *_likesLabel;
	UILabel *_likesCountLabel;
	
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
		_subscribesLabel.text = @"ProfileViewControllerSubscribesLabel".commonLocalizedString;
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
		
		bottomOffsetY += 42;
		
		_subscribersLabel = [[UILabel alloc] init];
		_subscribersLabel.backgroundColor = [UIColor clearColor];
		_subscribersLabel.font = [FontFactory fontWithType: FontTypeProfileLabels];
		_subscribersLabel.textColor = [FontFactory fontColorForType: FontTypeProfileLabels];
		_subscribersLabel.text = @"ProfileViewControllerSubscribersLabel".commonLocalizedString;
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
		
		//Bottom to top
		float offsetY = self.frame.size.height - 62;
//		62
		_fioLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY, self.frame.size.width, 22)];
		_fioLabel.backgroundColor = [UIColor clearColor];
		_fioLabel.font = [FontFactory fontWithType: FontTypeProfileFIO];
		_fioLabel.textAlignment = NSTextAlignmentCenter;
		_fioLabel.textColor = [FontFactory fontColorForType: FontTypeProfileFIO];
		[self addSubview: _fioLabel];
		
//		_checksLabel = [[UILabel alloc] init];
//		_checksLabel.backgroundColor = [UIColor clearColor];
//		_checksLabel.font = [FontFactory fontWithType: FontTypeProfileLabels];
//		_checksLabel.textColor = [FontFactory fontColorForType: FontTypeProfileLabels];
//		_checksLabel.text = @"ProfileViewControllerChecksCountLabel".commonLocalizedString;
//		[_checksLabel sizeToFit];
//		
//		_commentsLabel = [[UILabel alloc] init];
//		_commentsLabel.backgroundColor = [UIColor clearColor];
//		_commentsLabel.font = [FontFactory fontWithType: FontTypeProfileLabels];
//		_commentsLabel.textColor = [FontFactory fontColorForType: FontTypeProfileLabels];
//		_commentsLabel.text = @"ProfileViewControllerCommentsCountLabel".commonLocalizedString;
//		[_commentsLabel sizeToFit];
//		
//		_likesLabel = [[UILabel alloc] init];
//		_likesLabel.backgroundColor = [UIColor clearColor];
//		_likesLabel.font = [FontFactory fontWithType: FontTypeProfileLabels];
//		_likesLabel.textColor = [FontFactory fontColorForType: FontTypeProfileLabels];
//		_likesLabel.text = @"ProfileViewControllerLikesCountLabel".commonLocalizedString;
//		[_likesLabel sizeToFit];
    }
    return self;
}

- (void) setUserData: (LGUser *) user {
	[_avatarImageView loadWebImageWithSizeThatFitsName: user.avatar
										   placeholder: [ViewFactory sharedFactory].userProfileAvatarPlaceholder];
	NSString *format = @"%0d ";
	_subscribesCountLabel.text =	[[NSString alloc] initWithFormat: format, user.userSubscribes];
	_subscribersCountLabel.text =	[[NSString alloc] initWithFormat: format, user.userSubscribers];
	_checksCountLabel.text =		[[NSString alloc] initWithFormat: format, user.checksCount];
	_commentsCountLabel.text =		[[NSString alloc] initWithFormat: format, user.commentsCount];
	_likesCountLabel.text =			[[NSString alloc] initWithFormat: format, user.likesCount];
	
	_fioLabel.text = user.fio;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
