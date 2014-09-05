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
	UIImageView *_imageView;
	
	CAShapeLayer *_arcLayer;
	CALayer *_arcBgLayer;
	CAShapeLayer *_arcFillLayer;
	
	UIView *_drawingView;
}

@end

@implementation CheckDetailView

@dynamic progressValue;

#pragma mark - Properties

- (void) setDisplayPreview:(BOOL)displayPreview {
	if (_displayPreview != displayPreview) {
		if (displayPreview == YES) {
			[UIView animateWithDuration: kAnimationDuration
							 animations:^{
								 _drawingView.alpha = 0;
							 }];
		} else {
			[UIView animateWithDuration: kAnimationDuration
							 animations:^{
								 _drawingView.alpha = 1;
							 }];
		}
	}
	
	_displayPreview = displayPreview;
}

- (CGFloat) progressValue {
	CGFloat progress = 0;
	if (self.type == CheckDetailTypeOpen) {
		progress = _arcLayer.strokeEnd;
	} else if (self.type == CheckDetailTypeVote) {
		progress = _arcFillLayer.strokeEnd;
	}
	return progress;
}

- (void) setProgressValue:(CGFloat)progressValue {
	if (self.type == CheckDetailTypeOpen) {
		_arcLayer.strokeEnd = progressValue;
		[_arcLayer setNeedsDisplay];
	} else if (self.type == CheckDetailTypeVote) {
		_arcFillLayer.strokeEnd = progressValue;
		[_arcFillLayer setNeedsDisplay];
	}
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
		_progressLineWidth = progressLineWidth;
		
		//Configure image
		NSString *pathForResource = [[NSBundle mainBundle] pathForResource: @"DemoImage" ofType: @"jpg"];
		
		UIImage *image = [[UIImage alloc] initWithContentsOfFile: pathForResource];
		_image = [self generateThumbnailForImage: image];
		
		_imageView = [[UIImageView alloc] initWithImage: _image];
		
		CALayer *imageLayer = _imageView.layer;
        [imageLayer setCornerRadius: _imageView.frame.size.width / 2];
//        [imageLayer setBorderWidth:10];
        [imageLayer setMasksToBounds:YES];
		
		_imageView.center = CGPointMake(_imageView.center.x + self.imageCaps, _imageView.center.y + self.imageCaps);
		[self addSubview: _imageView];
		
		//Configure shape layer - which user actually see
		
		CGFloat drawingWidth = MIN(frame.size.width, frame.size.height);
		CGRect drawingFrame = CGRectMake(0, 0, drawingWidth, drawingWidth);
		CGFloat drawingRadius = drawingFrame.size.width / 2 - self.progressLineWidth / 2;
		
		_drawingView = [[UIView alloc] initWithFrame: drawingFrame];
		[self addSubview: _drawingView];
		
		UIBezierPath *emptyTimelinePath = [UIBezierPath bezierPathWithArcCenter: _drawingView.center
																		 radius: drawingRadius
																	 startAngle: -M_PI_2 endAngle: 3 * M_PI_2
																	  clockwise: YES];
		CAShapeLayer *emptyTimelineLayer = [[CAShapeLayer alloc] init];
		emptyTimelineLayer.frame = drawingFrame;
		emptyTimelineLayer.path = emptyTimelinePath.CGPath;
		emptyTimelineLayer.fillColor = [UIColor clearColor].CGColor;
		emptyTimelineLayer.strokeColor = [UIColor colorWithWhite: 1.0 alpha: 38.0/255.0].CGColor;
		emptyTimelineLayer.lineWidth = self.progressLineWidth;
		[_drawingView.layer addSublayer: emptyTimelineLayer];
		
		UIBezierPath *path = [UIBezierPath bezierPath];
		
		CGFloat startOffset = 0.06;
		
		[path addArcWithCenter: _drawingView.center radius: drawingRadius
					startAngle: -M_PI_2 + startOffset endAngle:3 * M_PI_2 + startOffset clockwise: YES];
		_arcLayer=[CAShapeLayer layer];
		_arcLayer.path=path.CGPath;
		_arcLayer.fillColor = [UIColor clearColor].CGColor;
		_arcLayer.strokeColor = [UIColor whiteColor].CGColor;
		_arcLayer.strokeEnd = 0;
		_arcLayer.lineWidth = self.progressLineWidth;
		_arcLayer.lineCap = kCALineCapRound;
		_arcLayer.frame = drawingFrame;
		
//		//Configure background for layer
//		
//		_arcBgLayer = [[CircleGradientLayer alloc] init];
//		_arcBgLayer.frame = drawingFrame;
//		
////		_arcBgLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor ];
////		_arcBgLayer.startPoint = CGPointMake(0,0.5);
////		_arcBgLayer.endPoint = CGPointMake(1,0.5);
//		_arcBgLayer.mask = _arcLayer;
//		
//		
//		[self.layer addSublayer: _arcBgLayer];
//		[_arcBgLayer setNeedsDisplay];
		
		[self refresh];
	}
	return self;
}

//- (void) drawRect:(CGRect)rect {
//	self.progressValue += 0.1;
//	_arcLayer.strokeEnd = self.progressValue;
//	
//}

#pragma mark - Methods

- (void) animateFadeIn {
	CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"opacity"];
	bas.duration = 0.5;
	bas.delegate=self;
	bas.fillMode = kCAFillModeForwards;
	bas.fromValue = [NSNumber numberWithInteger:0];
	bas.toValue = [NSNumber numberWithInteger:1];
	bas.removedOnCompletion = NO;
//		bas.additive = YES;
	[_arcBgLayer addAnimation:bas forKey:@"fadeIn"];
}

- (void) animateFadeOut {
	CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"opacity"];
	bas.duration = 0.5;
	bas.delegate=self;
	bas.fillMode = kCAFillModeForwards;
	bas.fromValue=[NSNumber numberWithInteger:1];
	bas.toValue=[NSNumber numberWithInteger:0];
	bas.removedOnCompletion = NO;
//		bas.additive = YES;
	[_arcBgLayer addAnimation:bas forKey:@"fadeOut"];
}

- (void) refresh {
	if (self.type == CheckDetailTypeOpen) {
		//Configure background for layer
		if (_arcBgLayer != nil && [_arcBgLayer isKindOfClass: [CircleGradientLayer class]] == NO) {
			[_arcBgLayer removeFromSuperlayer];
			_arcBgLayer = nil;
		}
		
		if (_arcBgLayer == nil) {
			_arcBgLayer = [[CircleGradientLayer alloc] init];
			_arcBgLayer.frame = _drawingView.bounds;
			_arcBgLayer.mask = _arcLayer;
			
			[_drawingView.layer addSublayer: _arcBgLayer];
			[_arcBgLayer setNeedsDisplay];
		}
	} else if (self.type == CheckDetailTypeVote) {
		//Configure background for layer
		if (_arcBgLayer != nil && [_arcBgLayer isKindOfClass: [CircleGradientLayer class]] == YES) {
			[_arcBgLayer removeFromSuperlayer];
			_arcBgLayer = nil;
		}
		
		_arcLayer.strokeEnd = 1.0;
		
		if (_arcBgLayer == nil) {
			_arcBgLayer = [[CALayer alloc] init];
			
			_arcBgLayer.frame = _drawingView.bounds;
			_arcBgLayer.backgroundColor = [UIColor colorWithRed: 255.0/255.0
														  green: 94.0/255.0
														   blue: 124.0/255.0 alpha: 1.0].CGColor;
			
	//		_arcBgLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor ];
	//		_arcBgLayer.startPoint = CGPointMake(0,0.5);
	//		_arcBgLayer.endPoint = CGPointMake(1,0.5);
			_arcBgLayer.mask = _arcLayer;
			
			[_drawingView.layer addSublayer: _arcBgLayer];
			[_arcBgLayer setNeedsDisplay];
			
			CGRect drawingFrame = _imageView.bounds;
			drawingFrame.origin.x = (_drawingView.frame.size.width - drawingFrame.size.width) / 2;
			drawingFrame.origin.y = (_drawingView.frame.size.height - drawingFrame.size.height) / 2;
			
			UIBezierPath *path = [UIBezierPath bezierPath];
			
//			[path addArcWithCenter: CGPointMake(CGRectGetMidX(_drawingView.frame), CGRectGetMidY(_drawingView.frame))
//							radius: _drawingView.frame.size.width / 2 - self.imageCaps
//						startAngle: -M_PI_2 endAngle:3 * M_PI_2 clockwise: YES];
			[path moveToPoint: CGPointMake(drawingFrame.size.width / 2, drawingFrame.size.height)];
			[path addLineToPoint: CGPointMake(drawingFrame.size.width / 2, 0)];
//			[path closePath];
			
			_arcFillLayer=[CAShapeLayer layer];
			_arcFillLayer.backgroundColor = [UIColor colorWithWhite: 0 alpha: 128.0/255.0].CGColor;
			_arcFillLayer.cornerRadius = drawingFrame.size.width / 2;
			_arcFillLayer.masksToBounds = YES;
			_arcFillLayer.path = path.CGPath;
			_arcFillLayer.lineWidth = drawingFrame.size.width;
			_arcFillLayer.strokeColor = [UIColor colorWithRed: 247.0/255.0 green: 43.0/255.0 blue: 146.0/255.0
														alpha: 204.0/255.0].CGColor;
			_arcFillLayer.strokeEnd = 0;
			_arcFillLayer.frame = drawingFrame;
			[_drawingView.layer addSublayer: _arcFillLayer];
			[_arcFillLayer setNeedsDisplay];
		}
	} else if (self.type == CheckDetailTypeClosed) {
		//Configure background for layer
		if (_arcBgLayer != nil && [_arcBgLayer isKindOfClass: [CircleGradientLayer class]] == YES) {
			[_arcBgLayer removeFromSuperlayer];
			_arcBgLayer = nil;
		}
		
		if (_arcBgLayer == nil) {
			_arcBgLayer = [[CALayer alloc] init];
			
			_arcBgLayer.frame = _drawingView.bounds;
			_arcBgLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
			
	//		_arcBgLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor ];
	//		_arcBgLayer.startPoint = CGPointMake(0,0.5);
	//		_arcBgLayer.endPoint = CGPointMake(1,0.5);
			_arcBgLayer.mask = _arcLayer;
			
			
			[_drawingView.layer addSublayer: _arcBgLayer];
			[_arcBgLayer setNeedsDisplay];
		}
	}
}

-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=5;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
	bas.removedOnCompletion = NO;
	bas.repeatCount = 5;
    [layer addAnimation:bas forKey:@"key"];
	
	CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = layer.frame;
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor ];
    gradientLayer.startPoint = CGPointMake(0,0.5);
    gradientLayer.endPoint = CGPointMake(1,0.5);
	
    [self.layer addSublayer:gradientLayer];
	//Using arc as a mask instead of adding it as a sublayer.
	//[self.view.layer addSublayer:arc];
	gradientLayer.mask = layer;
}

- (UIImage *) squareImageFromImage: (UIImage *) image {
    UIImage *squareImage = nil;
    CGSize imageSize = [image size];
    
    if (imageSize.width == imageSize.height) {
        squareImage = image;
    } else {
        // Compute square crop rect
        CGFloat smallerDimension = MIN(imageSize.width, imageSize.height);
        CGRect cropRect = CGRectMake(0, 0, smallerDimension, smallerDimension);
        
        // Center the crop rect either vertically or horizontally, depending on which dimension is smaller
        if (imageSize.width <= imageSize.height) {
            cropRect.origin = CGPointMake(0, rintf((imageSize.height - smallerDimension) / 2.0));
        } else {
            cropRect.origin = CGPointMake(rintf((imageSize.width - smallerDimension) / 2.0), 0);
        }
        
        CGImageRef croppedImageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        squareImage = [UIImage imageWithCGImage:croppedImageRef scale: image.scale orientation: UIImageOrientationUp];
        CGImageRelease(croppedImageRef);
//	// Create path.
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image.png"];
//
//	// Save image.
//	[UIImagePNGRepresentation(squareImage) writeToFile:filePath atomically:YES];
//
//	UIImage *storedImage = [UIImage imageWithContentsOfFile: filePath];
    }
    
    return squareImage;
}

- (UIImage *) generateThumbnailForImage: (UIImage *) image {
	CGFloat imageDiameter = MIN(self.frame.size.width, self.frame.size.height) - self.imageCaps * 2;
	CGRect contextBounds = CGRectZero;
	contextBounds.size = CGSizeMake(imageDiameter, imageDiameter);
	
	UIImage *sourceImage = image;
	UIImage *squareImage = [self squareImageFromImage: sourceImage];
	
	UIGraphicsBeginImageContextWithOptions(contextBounds.size, YES, 0.0);
	
	[squareImage drawInRect:contextBounds];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//	//Should be stored with scale == 1 for correct image dpi settings
//	UIImage *imageToStore = [UIImage imageWithCGImage: scaledImage.CGImage
//												scale: 1
//										  orientation: UIImageOrientationUp];
	
	UIGraphicsEndImageContext();
	
//	// Create path.
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image@2x.png"];
//	
//	// Save image.
//	[UIImagePNGRepresentation(imageToStore) writeToFile:filePath atomically:YES];
//	
//	UIImage *storedImage = [UIImage imageWithContentsOfFile: filePath];
	
	return scaledImage;
}

@end
