//
//  CheckDetailView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 08.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckDetailView.h"

#import "UIView+CGExtension.h"
#import "ViewFactory.h"

#define kAnimationDuration 0.4

@interface CheckDetailView () {
	CheckDrawingsDetailView *_drawingsView;
	
	UIImageView *_imageView;
	UIImageView *_userImageView;
	UIButton *_makePhotoButton;
	UIButton *_voteButton;
	
	UIScrollView *_scrollView;
}

@end

@implementation CheckDetailView

@dynamic userImage, progressValue;
@dynamic type;

#pragma mark - Properties

- (void) setDisplayPreview:(BOOL)displayPreview {
	_displayPreview = displayPreview;
}

- (UIImage *) userImage {
	return _userImageView.image;
}

- (void) setUserImage:(UIImage *)userImage {
	if (self.userImage != userImage) {
		_userImageView.image = userImage;
		if (userImage == nil) {
			_scrollView.contentOffset = CGPointZero;
			_scrollView.scrollEnabled = NO;
		} else {
			_scrollView.scrollEnabled = YES;
		}
		_makePhotoButton.selected = (userImage != nil);
	}
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
		
		UIButton *imageButton = [[UIButton alloc] initWithFrame: _imageView.frame];
		[imageButton addTarget: self action: @selector(imageAction:) forControlEvents: UIControlEventTouchUpInside];
		[_scrollView addSubview: imageButton];
		
		UIButton *userImageButton = [[UIButton alloc] initWithFrame: _userImageView.frame];
		[userImageButton addTarget: self action: @selector(userImageAction:) forControlEvents: UIControlEventTouchUpInside];
		[_scrollView addSubview: userImageButton];
		
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

- (void) refresh {
	if (self.type == CheckDetailTypeOpen) {
		if (_makePhotoButton == nil) {
			_makePhotoButton = [[ViewFactory sharedFactory] checkMakeFoto: self action: @selector(makePhotoAction:)];
			_makePhotoButton.frameX = 199;
			_makePhotoButton.frameY = 8;
			
			[self addSubview: _makePhotoButton];
		}
		_makePhotoButton.hidden = NO;
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

- (void) imageAction: (id) sender {
	[self.delegate imageAction];
}

- (void) userImageAction: (id) sender {
	[self.delegate userImageAction];
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
