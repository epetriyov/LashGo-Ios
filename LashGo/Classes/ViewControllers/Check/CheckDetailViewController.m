//
//  PhotoViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 05.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckDetailViewController.h"

#import "Kernel.h"
#import "UIImageView+LGImagesExtension.h"
#import "ViewFactory.h"

@interface CheckDetailViewController () <UIScrollViewDelegate> {
	UIButton __weak *_sendPhotoButton;
}

@property (nonatomic, weak) UIScrollView *imageZoomView;
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation CheckDetailViewController

- (void) loadView {
	[super loadView];
	
	[_titleBarView removeFromSuperview];
	UIButton *iconButton = [[ViewFactory sharedFactory] titleBarIconButtonWithTarget: self
																			  action: @selector(iconAction:)];
	UIButton *cameraButton = [[ViewFactory sharedFactory] titleBarCameraButtonWithTarget: self
																				  action: @selector(cameraAction:)];
	UIButton *sendPhotoButton = [[ViewFactory sharedFactory] titleBarSendPhotoButtonWithTarget: self
																						action: @selector(sendPhotoAction:)];
	_sendPhotoButton = sendPhotoButton;
	TitleBarView *tbView = [TitleBarView titleBarViewWithLeftSecondaryButton: iconButton
																 rightButton: cameraButton
														rightSecondaryButton: sendPhotoButton];
	tbView.titleLabel.text = self.check.name;
	[tbView.backButton addTarget: self action: @selector(backAction:)
				forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: tbView];
	_titleBarView = tbView;
	
	UIScrollView *imageZoomView = [[UIScrollView alloc] initWithFrame: self.contentFrame];
	imageZoomView.delegate = self;
	[self.view addSubview: imageZoomView];
	self.imageZoomView = imageZoomView;
	
	UIImageView *imageView = [[UIImageView alloc] init];
	imageView.contentMode = UIViewContentModeTopLeft;
	[_imageZoomView addSubview:imageView];
	_imageView = imageView;
	
	if (self.mode == CheckDetailViewModeAdminPhoto) {
		CheckDetailViewController __weak *wself = self;
		[self.imageView loadWebImageWithName: self.check.taskPhotoUrl placeholderImage: nil
								   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
									   [wself restoreZoomViewFor: image];
								   }];
	} else if (self.mode == CheckDetailViewModeUserPhoto) {
		self.imageView.image = self.check.currentPickedUserPhoto;
		[self restoreZoomViewFor: self.check.currentPickedUserPhoto];
	}
}

#pragma mark - Methods

- (void) restoreZoomViewFor: (UIImage *) image {
	[self.imageView sizeToFit];
	self.imageZoomView.contentSize = image.size;
	
	float scale = MAX(self.imageZoomView.frame.size.width / image.size.width,
					  self.imageZoomView.frame.size.height / image.size.height);
	self.imageZoomView.minimumZoomScale = scale;
	self.imageZoomView.zoomScale = scale;
}

#pragma mark - Actions

- (void) iconAction: (id) sender {
	
}

- (void) cameraAction: (id) sender {
	[kernel.imagePickManager takePictureFor: self.check];
}

- (void) sendPhotoAction: (id) sender {
	
}

#pragma mark - UIScrollViewDelegate implementation

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _imageView;
}

@end
