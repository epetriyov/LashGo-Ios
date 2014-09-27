//
//  CheckSimpleDetailView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 27.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckSimpleDetailView.h"

@interface CheckSimpleDetailView () {
	CheckDrawingsDetailView *_drawingsView;
	
	UIImageView *_imageView;
}

@end

@implementation CheckSimpleDetailView

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
		CGFloat _drawingsWidth = MIN(self.frame.size.width, self.frame.size.height);
		
		CGFloat imageViewDiameter = _drawingsWidth - self.imageCaps * 2;
		_imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, imageViewDiameter, imageViewDiameter)];
		_imageView.contentMode = UIViewContentModeCenter;
		CALayer *imageLayer = _imageView.layer;
        [imageLayer setCornerRadius: _imageView.frame.size.width / 2];
//        [imageLayer setBorderWidth:10];
        [imageLayer setMasksToBounds:YES];
		_imageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
		[self addSubview: _imageView];
		
		_drawingsView = [[CheckDrawingsDetailView alloc] initWithFrame: CGRectMake((self.frame.size.width - _drawingsWidth) / 2, (self.frame.size.height - _drawingsWidth) / 2, _drawingsWidth, _drawingsWidth)
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

@end
