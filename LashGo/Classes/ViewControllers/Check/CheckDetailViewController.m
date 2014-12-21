//
//  PhotoViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 05.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckDetailViewController.h"

#import "CheckCardTimerPanelView.h"
#import "PhotoCountersPanelView.h"
#import "Kernel.h"
#import "UIButton+LGImages.h"
#import "UIImageView+LGImagesExtension.h"
#import "ViewFactory.h"

@interface CheckDetailViewController () <UIScrollViewDelegate> {
	UIButton __weak *_sendPhotoButton;
	PhotoCountersPanelView __weak *_photoCountersPanelView;
}

@property (nonatomic, weak) UIScrollView *imageZoomView;
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation CheckDetailViewController

- (void) loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor colorWithRed: 235.0/255.0 green: 236.0/255.0 blue: 238.0/255.0
												alpha: 1.0];
	
	[_titleBarView removeFromSuperview];
	UIButton *iconButton = [[ViewFactory sharedFactory] titleBarIconButtonWithTarget: self
																			  action: @selector(iconAction:)];
	UIButton *sendPhotoButton = nil;
	UIButton *cameraButton = nil;
	if (self.check != nil) {
		[iconButton loadWebImageWithSizeThatFitsName: self.check.taskPhotoUrl placeholder: nil];
		if (self.check.currentPickedUserPhoto != nil) {
			sendPhotoButton = [[ViewFactory sharedFactory] titleBarSendPhotoButtonWithTarget: self
																					  action: @selector(sendPhotoAction:)];
		}
//		cameraButton = [[ViewFactory sharedFactory] titleBarCameraButtonWithTarget: self
//																			action: @selector(cameraAction:)];
	} else if (self.photo != nil) {
		if (self.photo.user != nil) {
			[iconButton loadWebImageWithSizeThatFitsName: self.photo.user.avatar
											 placeholder: [ViewFactory sharedFactory].titleBarAvatarPlaceholder];
		} else {
			[iconButton loadWebImageWithSizeThatFitsName: self.photo.check.taskPhotoUrl
											 placeholder: nil];
		}
		
	}
	
	_sendPhotoButton = sendPhotoButton;
	TitleBarView *tbView = [TitleBarView titleBarViewWithLeftSecondaryButton: iconButton
																 rightButton: cameraButton
														rightSecondaryButton: sendPhotoButton];
	if (self.check != nil) {
		tbView.titleLabel.text = self.check.name;
	} else if (self.photo != nil) {
		if (self.photo.user != nil) {
			tbView.titleLabel.text = self.photo.user.fio;
		} else {
			tbView.titleLabel.text = self.photo.check.name;
		}
	}
	
	[tbView.backButton addTarget: self action: @selector(backAction:)
				forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: tbView];
	_titleBarView = tbView;
	
	//Bottom to top
	float panelHeight = 44;
	UIView *panelBgView = [[UIView alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height - panelHeight,
																	self.view.frame.size.width, panelHeight)];
	panelBgView.backgroundColor = [UIColor colorWithWhite: 249.0/255.0 alpha: 1.0];
	[self.view addSubview: panelBgView];
	
	float countersHeight = 32;
	CheckCardTimerPanelView *panelView = [[CheckCardTimerPanelView alloc] initWithFrame: CGRectMake(0, panelHeight - countersHeight, panelBgView.frame.size.width, countersHeight)
																				   mode: CheckCardTimerPanelModeDark];
	[panelBgView addSubview: panelView];
	
	PhotoCountersPanelView *photoCountersView = [[PhotoCountersPanelView alloc] initWithFrame: CGRectMake(0, panelHeight - countersHeight, panelBgView.frame.size.width, countersHeight)];
	[photoCountersView.likesButton addTarget: self action: @selector(likesAction:)
							   forControlEvents: UIControlEventTouchUpInside];
	[photoCountersView.commentsButton addTarget: self action: @selector(commentsAction:)
					   forControlEvents: UIControlEventTouchUpInside];
	[panelBgView addSubview: photoCountersView];
	_photoCountersPanelView = photoCountersView;
	
	CGRect imageFrame = self.contentFrame;
	imageFrame.size.height = panelBgView.frame.origin.y - imageFrame.origin.y;
	
	UIScrollView *imageZoomView = [[UIScrollView alloc] initWithFrame: imageFrame];
	imageZoomView.delegate = self;
	[self.view addSubview: imageZoomView];
	self.imageZoomView = imageZoomView;
	
	UIImageView *imageView = [[UIImageView alloc] init];
	imageView.contentMode = UIViewContentModeTopLeft;
	[_imageZoomView addSubview:imageView];
	_imageView = imageView;
	
	if (self.photo != nil) {
		CheckDetailViewController __weak *wself = self;
		[self.imageView loadWebImageWithName: self.photo.url placeholderImage: nil
								   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
									   [wself restoreZoomViewFor: image];
								   }];
	} else {
		if (self.mode == CheckDetailViewModeAdminPhoto) {
			photoCountersView.hidden = YES;
			CheckDetailViewController __weak *wself = self;
			[self.imageView loadWebImageWithName: self.check.taskPhotoUrl placeholderImage: nil
									   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
										   [wself restoreZoomViewFor: image];
									   }];
		} else if (self.mode == CheckDetailViewModeUserPhoto) {
			if (self.check.userPhoto != nil) {
				CheckDetailViewController __weak *wself = self;
				[self.imageView loadWebImageWithName: self.check.userPhoto.url placeholderImage: nil
										   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
											   [wself restoreZoomViewFor: image];
										   }];
			} else {
				photoCountersView.hidden = YES;
				self.imageView.image = self.check.currentPickedUserPhoto;
				[self restoreZoomViewFor: self.check.currentPickedUserPhoto];
			}
		} else if (self.mode == CheckDetailViewModeWinnerPhoto) {
			CheckDetailViewController __weak *wself = self;
			[self.imageView loadWebImageWithName: self.check.winnerPhoto.url placeholderImage: nil
									   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
										   [wself restoreZoomViewFor: image];
									   }];
		}
	}
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
	LGPhoto *currentPhoto = [self currentNotAdminPhoto];
	if (currentPhoto != nil) {
		[kernel.checksManager getPhotoCountersForPhoto: currentPhoto];
	}
}

- (LGPhoto *) currentNotAdminPhoto {
	LGPhoto *currentPhoto = nil;
	if (self.mode == CheckDetailViewModeUserPhoto) {
		if (self.check.userPhoto != nil) {
			currentPhoto = self.check.userPhoto;
		} else {
			currentPhoto = self.photo;
		}
	} else if (self.mode == CheckDetailViewModeWinnerPhoto) {
		currentPhoto = self.check.winnerPhoto;
	}
	return currentPhoto;
}

#pragma mark - Methods

- (void) refreshCounters {
	LGPhoto *photo = [self currentNotAdminPhoto];
	if (photo != nil) {
		_photoCountersPanelView.commentsCount = photo.counters.commentsCount;
		_photoCountersPanelView.likesCount = photo.counters.likesCount;
	}
}

- (void) restoreZoomViewFor: (UIImage *) image {
	[self.imageView sizeToFit];
	self.imageZoomView.contentSize = image.size;
	
	float minScale;
	float minWidthScale = self.imageZoomView.frame.size.width / image.size.width;
	float minHeightScale = self.imageZoomView.frame.size.height / image.size.height;
	
	if (minWidthScale < minHeightScale) {
		minScale = minWidthScale;
		float heightDifference = CGRectGetHeight(self.imageZoomView.bounds) -  minWidthScale * image.size.height;
		self.imageZoomView.contentInset = UIEdgeInsetsMake(heightDifference / 2, 0, 0, 0);
	} else {
		minScale = minHeightScale;
		float widthDifference = CGRectGetWidth(self.imageZoomView.bounds) -  minHeightScale * image.size.width;
		self.imageZoomView.contentInset = UIEdgeInsetsMake(0, widthDifference / 2, 0, 0);
	}
	
	self.imageZoomView.minimumZoomScale = minScale;
	self.imageZoomView.zoomScale = minScale;
}

#pragma mark - Actions

- (void) iconAction: (id) sender {
	if (self.check != nil) {
		[kernel.checksManager openCheckCardViewControllerFor: self.check];
	} else if (self.photo != nil) {
		if (self.photo.user != nil) {
			[kernel.userManager openProfileViewControllerWith: self.photo.user];
		} else if (self.photo.check != nil) {
			[kernel.checksManager openCheckCardViewControllerForCheckUID: self.photo.check.uid];
		}
	}
}

- (void) cameraAction: (id) sender {
	[kernel.imagePickManager takePictureFor: self.check];
}

- (void) sendPhotoAction: (id) sender {
	
}

- (void) likesAction: (id) sender {
	LGPhoto *photo = [self currentNotAdminPhoto];
	if (photo != nil) {
		[kernel.checksManager openPhotoVotesViewControllerFor: photo];
	}
}

- (void) commentsAction: (id) sender {
	if (self.photo != nil) {
		[kernel.checksManager openPhotoCommentsViewControllerFor: self.photo];
	} else {
		if (self.mode == CheckDetailViewModeUserPhoto) {
			[kernel.checksManager openPhotoCommentsViewControllerFor: self.check.userPhoto];
		} else if (self.mode == CheckDetailViewModeWinnerPhoto) {
			[kernel.checksManager openPhotoCommentsViewControllerFor: self.check.winnerPhoto];
		}
	}
}

#pragma mark - UIScrollViewDelegate implementation

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _imageView;
}

@end
