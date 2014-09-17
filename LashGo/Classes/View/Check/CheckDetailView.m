//
//  CheckDetailView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 08.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckDetailView.h"
#import "ViewFactory.h"

#define kAnimationDuration 0.4

@interface CheckDetailView () {
	CheckDrawingsDetailView *_drawingsView;
	
	UIImageView *_imageView;
}

@end

@implementation CheckDetailView

@dynamic image;

#pragma mark - Properties

- (void) setDisplayPreview:(BOOL)displayPreview {
	_displayPreview = displayPreview;
}

- (UIImage *) image {
	return _imageView.image;
}

- (void) setImage:(UIImage *)image {
	if (self.image != image) {
		_imageView.image = image;
	}
}

- (void) setProgressValue:(CGFloat)progressValue {
	_drawingsView.progressValue = progressValue;
}

- (void) setType:(CheckDetailType)type {
	_drawingsView.type = type;
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
		UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake((self.frame.size.width - scrollableWidth) / 2, 0,
																				   scrollableWidth, scrollableWidth)];
		scrollView.clipsToBounds = NO;
		scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, scrollView.frame.size.height);
		scrollView.pagingEnabled = YES;
		scrollView.showsHorizontalScrollIndicator = NO;
		[self addSubview: scrollView];
		
		CGFloat imageViewDiameter = MIN(self.frame.size.width, self.frame.size.height) - self.imageCaps * 2;
		_imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, imageViewDiameter, imageViewDiameter)];
		_imageView.contentMode = UIViewContentModeScaleAspectFill;
		
		CALayer *imageLayer = _imageView.layer;
        [imageLayer setCornerRadius: _imageView.frame.size.width / 2];
//        [imageLayer setBorderWidth:10];
        [imageLayer setMasksToBounds:YES];
		
		_imageView.center = CGPointMake(_imageView.center.x + self.imageCaps, _imageView.center.y + self.imageCaps);
		[scrollView addSubview: _imageView];
		
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
	[_drawingsView refresh];
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
