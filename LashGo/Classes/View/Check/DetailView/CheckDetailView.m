//
//  CheckDetailView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 08.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckDetailView.h"

#import "UIImageView+LGImagesExtension.h"
#import "UIView+CGExtension.h"
#import "ViewFactory.h"

#import "CheckDetailCheckOverlay.h"
#import "CheckDetailUserOverlay.h"
#import "CheckDetailWinnerOverlay.h"

#define kAnimationDuration 0.4

@interface CheckDetailView () <CheckDetailOverlayDelegate> {
	CheckDrawingsDetailView *_drawingsView;
	
	UIImageView *_imageView;
	UIImageView *_userImageView;
	UIButton *_makePhotoButton;
	UIButton *_voteButton;
	
	CheckDetailUserOverlay *_userOverlay;
	CheckDetailWinnerOverlay *_winnerOverlay;
	
	UIScrollView *_scrollView;
}

@end

@implementation CheckDetailView

@dynamic progressValue;
@dynamic type;

#pragma mark - Properties

- (void) setDisplayPreview:(BOOL)displayPreview {
	_displayPreview = displayPreview;
}

- (CGFloat) progressValue {
	return _drawingsView.progressValue;
}

- (void) setProgressValue:(CGFloat)progressValue {
	_drawingsView.progressValue = progressValue;
}

- (CheckDetailType) type {
	return _drawingsView.type;
}

- (void) setType:(CheckDetailType)type {
	_drawingsView.type = type;
	[self refresh];
}

#pragma mark - Standard

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame imageCaps: 18 progressLineWidth: 10];
    return self;
}

- (instancetype) initWithFrame: (CGRect) frame
					 imageCaps: (CGFloat) imageCaps
			 progressLineWidth: (CGFloat) progressLineWidth {
	if (self = [super initWithFrame: frame]) {
		_imageCaps = imageCaps;
		
		//Configure image
		float scrollableWidth = MIN(self.frame.size.width, self.frame.size.height);
		_scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake((self.frame.size.width - scrollableWidth) / 2, 0,
																				   scrollableWidth, scrollableWidth)];
		_scrollView.clipsToBounds = NO;
		_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 2, _scrollView.frame.size.height);
		_scrollView.pagingEnabled = YES;
		_scrollView.showsHorizontalScrollIndicator = NO;
		[self addSubview: _scrollView];
		
		CGFloat imageViewDiameter = MIN(self.frame.size.width, self.frame.size.height) - self.imageCaps * 2;
		_imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, imageViewDiameter, imageViewDiameter)];
		_imageView.contentMode = UIViewContentModeScaleAspectFill;
		CALayer *imageLayer = _imageView.layer;
        [imageLayer setCornerRadius: _imageView.frame.size.width / 2];
//        [imageLayer setBorderWidth:10];
        [imageLayer setMasksToBounds:YES];
		_imageView.center = CGPointMake(_imageView.center.x + self.imageCaps, _imageView.center.y + self.imageCaps);
		[_scrollView addSubview: _imageView];
		
		_userImageView = [[UIImageView alloc] initWithFrame: CGRectOffset(_imageView.frame, _scrollView.frame.size.width, 0)];
		_userImageView.contentMode = UIViewContentModeCenter;
		CALayer *_userImageLayer = _userImageView.layer;
        [_userImageLayer setCornerRadius: _userImageView.frame.size.width / 2];
        [_userImageLayer setMasksToBounds:YES];
		[_scrollView addSubview: _userImageView];
		
		CheckDetailCheckOverlay *checkOverlay = [[CheckDetailCheckOverlay alloc] initWithFrame: _imageView.frame];
		checkOverlay.delegate = self;
		[_scrollView addSubview: checkOverlay];
		
		CheckDetailUserOverlay *userOverlay = [[CheckDetailUserOverlay alloc] initWithFrame: _userImageView.frame];
		userOverlay.delegate = self;
		userOverlay.hidden = YES;
		[_scrollView addSubview: userOverlay];
		_userOverlay = userOverlay;
		
		CheckDetailWinnerOverlay *winnerOverlay = [[CheckDetailWinnerOverlay alloc] initWithFrame: _userImageView.frame];
		winnerOverlay.delegate = self;
		winnerOverlay.hidden = YES;
		[_scrollView addSubview: winnerOverlay];
		_winnerOverlay = winnerOverlay;
		
		_scrollView.scrollEnabled = NO;
		
		CGFloat _drawingsWidth = MIN(self.frame.size.width, self.frame.size.height);
		
		_drawingsView = [[CheckDrawingsDetailView alloc] initWithFrame: CGRectMake((self.frame.size.width - _drawingsWidth) / 2, 0, _drawingsWidth, _drawingsWidth)
															 imageCaps: imageCaps
													 progressLineWidth: progressLineWidth];
		[self addSubview: _drawingsView];
	}
	return self;
}

#pragma mark - Methods

- (void) setImageWithURLString: (NSString *) url {
	[_imageView loadWebImageWithSizeThatFitsName: url placeholder: nil];
}

- (void) setUserImagesWithCheck: (LGCheck *) check {
	_winnerOverlay.fio.text = check.winnerPhoto.user.fio;
	if (self.type == CheckDetailTypeClosed) {
		[self setUserImageWinnerWithURLString: check.winnerPhoto.url];
	} else if (self.type == CheckDetailTypeOpen) {
		if (check.userPhoto != nil) {
			[self setUserImageWithURLString: check.userPhoto.url];
		} else {
			[self setUserImageWithImage: check.currentPickedUserPhoto];
		}
	} else {
		[self setUserImageWithImage: nil];
	}
}

- (void) setUserImageWithImage: (UIImage *) image {
	[_userImageView cancelWebImageLoad];
//	if (_userImageView.image != image) {
	
		if (image == nil) {
			_userImageView.image = nil;
			
			_scrollView.contentOffset = CGPointZero;
			_scrollView.scrollEnabled = NO;
			_userOverlay.hidden = YES;
			_winnerOverlay.hidden = YES;
		} else {
			[_userImageView loadSizeThatFits: image];
			
			_scrollView.scrollEnabled = YES;
			_userOverlay.hidden = NO;
			_userOverlay.isSendHidden = NO;
			_makePhotoButton.hidden = NO;
			_winnerOverlay.hidden = YES;
		}
		_makePhotoButton.selected = (image != nil);
//	}
}

- (void) setUserImageWithURLString: (NSString *) url {
	[_userImageView loadWebImageWithSizeThatFitsName: url placeholder: nil];
	if (url == nil) {
		_scrollView.contentOffset = CGPointZero;
		_scrollView.scrollEnabled = NO;
		_userOverlay.hidden = YES;
		_winnerOverlay.hidden = YES;
	} else {
		_scrollView.scrollEnabled = YES;
		_userOverlay.hidden = NO;
		_userOverlay.isSendHidden = YES;
		_makePhotoButton.hidden = YES;
		_winnerOverlay.hidden = YES;
	}
}

- (void) setUserImageWinnerWithURLString: (NSString *) url {
	[_userImageView loadWebImageWithSizeThatFitsName: url placeholder: nil];
	if (url == nil) {
		_scrollView.contentOffset = CGPointZero;
		_scrollView.scrollEnabled = NO;
		_userOverlay.hidden = YES;
		_winnerOverlay.hidden = YES;
	} else {
		[_scrollView scrollRectToVisible: CGRectOffset(_scrollView.bounds, _scrollView.frame.size.width, 0)
								animated: NO];
		_scrollView.scrollEnabled = YES;
		_userOverlay.hidden = YES;
		_winnerOverlay.hidden = NO;
	}
}

- (void) refresh {
	if (self.type == CheckDetailTypeOpen) {
		if (_makePhotoButton == nil) {
			_makePhotoButton = [[ViewFactory sharedFactory] checkMakeFoto: self action: @selector(makePhotoAction:)];
			_makePhotoButton.frameX = 199;
			_makePhotoButton.frameY = 8;
			
			[self addSubview: _makePhotoButton];
		}
		_makePhotoButton.hidden = _userOverlay.isSendHidden;
		_voteButton.hidden = YES;
	} else if (self.type == CheckDetailTypeVote) {
		if (_voteButton == nil) {
			_voteButton = [[ViewFactory sharedFactory] checkVote: self action: @selector(voteAction:)];
			_voteButton.frameX = 199;
			_voteButton.frameY = 8;
			
			[self addSubview: _voteButton];
		}
		_makePhotoButton.hidden = YES;
		_voteButton.hidden = NO;
	} else if (self.type == CheckDetailTypeClosed) {
		_makePhotoButton.hidden = YES;
		_voteButton.hidden = YES;
	}
	[_drawingsView refresh];
}

- (void) makePhotoAction: (id) sender {
	[self.delegate makePhotoAction];
}

- (void) voteAction: (id) sender {
	[self.delegate voteAction];
}

#pragma mark - CheckDetailOverlayDelegate implementation

- (void) overlay: (CheckDetailOverlay *) overlay action: (CheckDetailOverlayAction) action {
	switch (action) {
		case CheckDetailOverlayActionCheckTapped:
			[self.delegate imageAction];
			break;
		case CheckDetailOverlayActionUserImageTapped:
			[self.delegate userImageAction];
			break;
		case CheckDetailOverlayActionSendUserImageTapped:
			[self.delegate sendUserImageAction];
			break;
		case CheckDetailOverlayActionWinnerImageTapped:
			[self.delegate winnerImageAction];
			break;
		default:
			break;
	}
}

#pragma mark - UIScrollViewDelegate implementation

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//	_checkView.displayPreview = scrollView.contentOffset.x > 0;
//	//	if (scrollView.contentOffset.x < scrollView.frame.size.width) {
//	_userPhotoView.displayPreview = scrollView.contentOffset.x < scrollView.frame.size.width;
//	//	}
//	
//}

@end
